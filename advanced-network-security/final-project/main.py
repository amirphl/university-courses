import os
import sys
import pickle
from math import sqrt
from collections import defaultdict
from scapy.all import *
from scapy.packet import Packet
import numpy as np
from scipy.cluster.hierarchy import linkage, dendrogram
import matplotlib.pyplot as plt

TCP = "TCP"
UDP = "UDP"
IP = "IP"
MAX_UDP_DIFF = 60  # seconds
FLOWS = defaultdict(list)


def create_tcp_flow(key, dataset_name, pkt: Packet):
    FLOWS[key].append(
        {
            "start_time": pkt.time,
            "end_time": pkt.time,
            "num_packets": 1,
            "total_bytes": len(pkt),
            "SYN_ACK": False,
            "terminated": False,
            "dataset_name": dataset_name,
        }
    )


def create_udp_flow(key, dataset_name, pkt: Packet):
    FLOWS[key].append(
        {
            "start_time": pkt.time,
            "end_time": pkt.time,
            "num_packets": 1,
            "total_bytes": len(pkt),
            "dataset_name": dataset_name,
        }
    )


def add_packet_to_flow(key, pkt: Packet):
    FLOWS[key][-1]["num_packets"] += 1
    FLOWS[key][-1]["total_bytes"] += len(pkt)
    FLOWS[key][-1]["end_time"] = pkt.time


def process_packet(pkt: Packet, dataset_name: str):
    src_ip, dst_ip = None, None

    if IP in pkt:
        src_ip = pkt[IP].src
        dst_ip = pkt[IP].dst

    if TCP in pkt:
        src_port = pkt[TCP].sport
        dst_port = pkt[TCP].dport
        protocol = "TCP"

        flow_key = (src_ip, src_port, dst_ip, dst_port, protocol)
        reverse_flow_key = (dst_ip, dst_port, src_ip, src_port, protocol)

        # SYN
        if pkt[TCP].flags.S and not pkt[TCP].flags.A:
            create_tcp_flow(flow_key, dataset_name, pkt)
            return

        # SYN-ACK
        if pkt[TCP].flags.S and pkt[TCP].flags.A:
            # TODO FIX What if a node sends packets with SYN-ACK flag set
            # on the fly?
            FLOWS[reverse_flow_key][-1]["SYN_ACK"] = True
            add_packet_to_flow(reverse_flow_key, pkt)
            return

        # FIN or RST
        if pkt[TCP].flags.R or pkt[TCP].flags.F:
            for key in [flow_key, reverse_flow_key]:
                if len(FLOWS[key]) > 0:
                    FLOWS[key][-1]["terminated"] = True
                    add_packet_to_flow(key, pkt)
            return

        for key in [flow_key, reverse_flow_key]:
            if len(FLOWS[key]) > 0 and not FLOWS[key][-1]["terminated"]:
                add_packet_to_flow(key, pkt)

    elif UDP in pkt:
        src_port = pkt[UDP].sport
        dst_port = pkt[UDP].dport
        protocol = "UDP"

        flow_key = (src_ip, src_port, dst_ip, dst_port, protocol)
        reverse_flow_key = (dst_ip, dst_port, src_ip, src_port, protocol)

        num_flows = len(FLOWS[flow_key])
        num_reverse_flows = len(FLOWS[reverse_flow_key])

        t = pkt.time

        if num_flows != 0 and num_reverse_flows != 0:
            end_time = FLOWS[flow_key][-1]["end_time"]
            reverse_end_time = FLOWS[reverse_flow_key][-1]["end_time"]

            # This should *not* happen.
            # TODO FIX What if it's a new flow?
            if t - end_time <= MAX_UDP_DIFF and t - reverse_end_time <= MAX_UDP_DIFF:
                add_packet_to_flow(flow_key, pkt)
            elif t - end_time > MAX_UDP_DIFF and t - reverse_end_time > MAX_UDP_DIFF:
                create_udp_flow(flow_key, dataset_name, pkt)
            elif t - end_time <= MAX_UDP_DIFF:
                add_packet_to_flow(flow_key, pkt)
            else:  # t - reverse_start_time <= DELTA
                add_packet_to_flow(reverse_flow_key, pkt)
        elif num_flows == 0 and num_reverse_flows == 0:
            create_udp_flow(flow_key, dataset_name, pkt)
        elif num_flows != 0:
            end_time = FLOWS[flow_key][-1]["end_time"]

            if t - end_time > MAX_UDP_DIFF:
                create_udp_flow(flow_key, dataset_name, pkt)
            else:
                add_packet_to_flow(flow_key, pkt)
        else:
            reverse_end_time = FLOWS[reverse_flow_key][-1]["end_time"]

            if t - reverse_end_time > MAX_UDP_DIFF:
                create_udp_flow(flow_key, dataset_name, pkt)
            else:
                add_packet_to_flow(reverse_flow_key, pkt)


def generate_flows(pcap_dir_path: str):
    pcap_dir_path = os.path.abspath(pcap_dir_path)

    for root, subdirs, files in os.walk(pcap_dir_path):
        print("--\nroot = " + root)

        for subdir in subdirs:
            print("\t- subdirectory " + subdir)

        for filename in files:
            file_path = os.path.join(root, filename)

            print("\t- file %s (full path: %s)" % (filename, file_path))

            if not file_path.endswith(".pcap"):
                continue

            for pkt in PcapReader(file_path):
                try:
                    process_packet(pkt, filename)
                except Exception as e:
                    sys.stdout.write(str(e))
                    sys.stdout.write(": ")
                    sys.stdout.write(str(pkt))
                    sys.stdout.write("\n")


def save_flows(filename="all_flows.pkl"):
    with open(filename, "wb") as fp:
        pickle.dump(FLOWS, fp)
    print(f"saved flows into {filename}")


def filter_flows():
    global FLOWS
    num_flows_per_src_dst = defaultdict(int)
    num_tcp_flows = 0
    num_incompleted_handshaked_flows = 0

    # Filter incompleted TCP handshakes
    for flow_key, flows_data in FLOWS.items():
        src_ip, _, dst_ip, _, protocol = flow_key
        if protocol == "TCP":
            num_flows = len(flows_data)
            num_tcp_flows += num_flows
            flows_data = [f for f in flows_data if f["SYN_ACK"]]
            num_incompleted_handshaked_flows += num_flows - len(flows_data)
            FLOWS[flow_key] = flows_data

        src_dst = (src_ip, dst_ip)
        num_flows_per_src_dst[src_dst] += len(flows_data)

    print("number TCP flows: ", num_tcp_flows)
    print(
        "number of incompleted TCP handshaked flows (removed): ",
        num_incompleted_handshaked_flows,
    )

    reverse_num_flows_per_src_dst = defaultdict(set)
    for key, num in num_flows_per_src_dst.items():
        reverse_num_flows_per_src_dst[num].add(key)

    # Plot Number of Flows per Pair
    x_values = list(reverse_num_flows_per_src_dst.keys())
    y_values = [len(x) for x in reverse_num_flows_per_src_dst.values()]
    x_values, y_values = zip(*sorted(zip(x_values, y_values)))
    plt.plot(x_values, y_values, marker="o", linestyle="-", color="b")
    plt.xlabel("Number of Flows per (Local IP, Remote IP) Pair")
    plt.ylabel("Number of Pairs")
    plt.title("Number of Flows per Pair")
    plt.grid(True)
    plt.show()

    # Filter the traffic of (local IP, remote IP)
    # pairs which have less than four flows.
    FILTERED = {}
    num_removed_flows_less_four = 0

    for flow_key, flows_data in FLOWS.items():
        src_ip, _, dst_ip, _, _ = flow_key
        c = num_flows_per_src_dst[(src_ip, dst_ip)]
        if c >= 4:
            FILTERED[flow_key] = flows_data
        else:
            num_removed_flows_less_four += len(flows_data)
            reverse_num_flows_per_src_dst[c].discard((src_ip, dst_ip))
    FLOWS = FILTERED

    print(
        f"result of filtering the traffic of (local IP, remote IP) pairs which have less than four flows: removed {num_removed_flows_less_four} flows"
    )

    # Plot Number of Flows per Pair After Filtering (local IP, remote IP)
    # With Less Than 4 Flows
    x_values = list(reverse_num_flows_per_src_dst.keys())
    y_values = [len(x) for x in reverse_num_flows_per_src_dst.values()]
    x_values, y_values = zip(*sorted(zip(x_values, y_values)))
    plt.plot(x_values, y_values, marker="o", linestyle="-", color="b")
    plt.xlabel("Number of Flows per (Local IP, Remote IP) Pair")
    plt.ylabel("Number of Pairs")
    plt.title(
        "Number of Flows per Pair After Filtering (local IP, remote IP) With Less Than 4 Flows"
    )
    plt.grid(True)
    plt.show()

    FILTERED = {}
    num_flows_more_100_pkts = 0

    # Filter flows with more that 100 packets
    for flow_key, flows_data in FLOWS.items():
        initial_num_flows = len(flows_data)
        flows_data = [f for f in flows_data if f["num_packets"] < 100]
        num_flows_more_100_pkts += initial_num_flows - len(flows_data)
        if len(flows_data) > 0:
            FILTERED[flow_key] = flows_data

    FLOWS = FILTERED

    print(f"filtered {num_flows_more_100_pkts} flows which had more than 100 packets")

    save_flows(filename="filtered_flows.pkl")


# TODO write tests, analyse with prints
# TODO rerun for whole dataset
# TODO stats
# TODO Tune S_dep_th, epoch, T_dep
# TODO N_dep table 2, you must set N_dep to 1??
# TODO fig 6
# TODO dist_h = 0.6, s_depth = 0.5 and 0.9
# TODO DR, FPR, ROC, dist_h from 0.1 to 0.9
def extract_two_level_flow_dependencies(candidates, T_dep, N_dep, S_dep_th):
    F = candidates

    # Step 1: Compute the number of occurrences for each flow fi in F
    occurrences = defaultdict(int)
    for flow_key in F:
        src_ip, _, dst_ip, _, protocol = flow_key
        # Ignore ports.
        new_flow_key = (src_ip, dst_ip, protocol)
        occurrences[new_flow_key] += 1

    # Step 2: Group flows based on the local host h
    grouped_flows = defaultdict(list)
    for flow_key, flows in F.items():
        src_ip, _, dst_ip, _, protocol = flow_key
        host_key = (src_ip, protocol)
        for flow in flows:
            grouped_flows[host_key].append(((src_ip, dst_ip, protocol), flow))

    # Step 3-5: Loop through flows and find dependent flows
    # Set to store candidate flow dependencies
    D = set()
    # Dictionary to store the number of times flow fj happens
    # shortly after flow fi
    Tij = defaultdict(int)

    for host_flows in grouped_flows.values():
        host_flows.sort(key=lambda x: x[1]["start_time"])

        for i, fi in enumerate(host_flows):
            # TODO Why T_dep? related to epoch
            for fj in host_flows[i + 1 :]:
                if fj[0] == fi[0]:
                    # TODO What about breaking here?
                    continue
                if fj[1]["start_time"] - fi[1]["start_time"] > T_dep:
                    break

                if abs(occurrences[fi[0]] - occurrences[fj[0]]) < N_dep:
                    flow_pair = (fi[0], fj[0])
                    D.add(flow_pair)
                    Tij[flow_pair] += 1
                    # print(flow_pair)

    # Step 13-16: Compute the score and label true flow dependencies
    true_flow_dependencies = set()
    for fi, fj in D:
        Ni = occurrences[fi]
        Nj = occurrences[fj]
        score = Tij[(fi, fj)] / sqrt(Ni * Nj)

        if score > S_dep_th:
            true_flow_dependencies.add((score, (fi, fj)))

    return true_flow_dependencies


def save_two_lvl_flow_dependencies(
    two_lvl_flow_deps,
    T_dep,
    N_dep,
    S_dep_th,
    filename="two_level_flow_dependencies.pkl",
):
    path = f"T_dep={T_dep}-N_dep={N_dep}-S_dep_th={S_dep_th}-{filename}"
    with open(path, "wb") as fp:
        pickle.dump(two_lvl_flow_deps, fp)
    print(f"saved two level flow dependencies into {path}")


def make_new_dependency(frst_dep, scnd_dep, k_lvl_deps, S_dep_th):
    new_score = frst_dep[0] * scnd_dep[0]

    if new_score < S_dep_th:
        return

    new_dep = frst_dep[1] + scnd_dep[1][1:]
    new_entry = (new_score, new_dep)
    level = len(new_dep)
    if level <= len(k_lvl_deps.keys()):
        k_lvl_deps[level].add(new_entry)
    else:
        k_lvl_deps[level] = {new_entry}
    # print(frst_dep, scnd_dep, new_entry, sep=" ++ ")
    # print("-------------")


def find_3_lvl_flow_dependencies(two_lvl_flow_deps, S_dep_th):
    k_lvl_deps = {1: set(), 2: two_lvl_flow_deps, 3: set()}

    g = defaultdict(list)

    for dep in two_lvl_flow_deps:
        _, (fi, fj) = dep
        g[fi].append(dep)

    for dep in two_lvl_flow_deps:
        _, (fi, fj) = dep
        for scnd_dep in g[fj]:
            if dep == scnd_dep:
                continue
            make_new_dependency(dep, scnd_dep, k_lvl_deps, S_dep_th)

    return k_lvl_deps


def find_k_lvl_flow_dependencies(two_lvl_flow_deps, K, S_dep_th):
    if K == 3:
        return find_3_lvl_flow_dependencies(two_lvl_flow_deps, S_dep_th)

    k_lvl_deps = {1: set(), 2: two_lvl_flow_deps}

    combinations_seen = set()
    min_lvl_generated = 2
    max_lvl_seen = 2

    while min_lvl_generated < K:
        for i in range(2, max_lvl_seen + 1):
            for j in range(i, max_lvl_seen + 1):
                if (i, j) in combinations_seen:
                    # print("seen", (i, j))
                    continue
                for i_dep in k_lvl_deps[i]:
                    for j_dep in k_lvl_deps[j]:
                        # TODO FIX
                        if i_dep == j_dep:
                            continue
                        if i_dep[1][-1] == j_dep[1][0]:
                            make_new_dependency(i_dep, j_dep, k_lvl_deps, S_dep_th)
                        if j_dep[1][-1] == i_dep[1][0]:
                            make_new_dependency(j_dep, i_dep, k_lvl_deps, S_dep_th)
                if i + j - 1 not in k_lvl_deps.keys():
                    k_lvl_deps[i + j - 1] = set()
                combinations_seen.add((i, j))
        min_lvl_generated = max_lvl_seen + 1
        max_lvl_seen = len(k_lvl_deps)

    return k_lvl_deps


def save_k_lvl_flow_dependencies(
    k_lvl_flow_deps,
    k,
):
    path = f"{k}-level-flow-dependencies.pkl"
    with open(path, "wb") as fp:
        pickle.dump(k_lvl_flow_deps, fp)
    print(f"saved k level flow dependencies into {path}")


def compute_distance_matrix(k_lvl_deps, K):
    # k_lvl_deps = {2: k_lvl_deps}
    DEP = defaultdict(set)
    HOSTS = set()

    for i in range(2, K + 1):
        deps = k_lvl_deps[i]
        for dep in deps:
            _, flows = dep
            src_ip, _, _ = flows[0]
            HOSTS.add(src_ip)
            for flow in flows:
                next_src_ip, dst_ip, _ = flow
                if next_src_ip != src_ip:
                    print("damn, something went wrong!")
                key = (src_ip, i)
                DEP[key].add(dst_ip)

    SIM = {}

    for frst_host in HOSTS:
        for scnd_host in HOSTS:
            for i in range(2, K + 1):
                frst_DEP = DEP[(frst_host, i)]
                scnd_DEP = DEP[(scnd_host, i)]
                intersection = len(frst_DEP.intersection(scnd_DEP)) * 1.0
                union = len(frst_DEP.union(scnd_DEP))
                key = (frst_host, scnd_host, i)
                SIM[key] = intersection / union if union != 0 else 0
                # print(key, SIM[key])

    Wk = [
        0,
        0,
    ]
    # n = len(HOSTS)
    # SIGMA = (n * (n + 1) / 2) - 1
    SIGMA = (K * (K + 1) / 2) - 1

    # for i in range(2, n + 1):
    for i in range(2, K + 1):
        Wk.append(1.0 * i / SIGMA)

    DIST = defaultdict(dict)
    for frst_host in HOSTS:
        for scnd_host in HOSTS:
            d = 0
            # for i in range(2, n + 1):
            for i in range(2, K + 1):
                key = (frst_host, scnd_host, i)
                d += Wk[i] * (1 - SIM[key])
            DIST[frst_host][scnd_host] = d

    return DIST


def save_distance_matrix(dist_mat):
    path = "distance_matrix.pkl"
    with open(path, "wb") as fp:
        pickle.dump(dist_mat, fp)
    print(f"saved distance matrix into {path}")


def clustering(initial_dist_mat):
    # Get a list of unique hosts
    hosts = list(initial_dist_mat.keys())

    # Convert the distance dictionary to a condensed distance matrix
    num_hosts = len(hosts)
    dist_matrix = np.zeros((num_hosts, num_hosts))
    for i, a in enumerate(hosts):
        for j, b in enumerate(hosts):
            dist_matrix[i, j] = initial_dist_mat[a][b]

    # Perform linkage hierarchical clustering
    Z = linkage(dist_matrix, method="single")

    # Plot the dendrogram
    plt.figure(figsize=(10, 5))
    dendrogram(Z, labels=hosts, orientation="top", leaf_rotation=45, leaf_font_size=10)
    plt.title("Hierarchical Clustering Dendrogram")
    plt.xlabel("Hosts")
    plt.ylabel("Distance")
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    command = None

    try:
        command = sys.argv[1]
    except IndexError:
        sys.stderr.write("command not found.")
        exit(1)

    if command == "generate_flows":
        try:
            pcap_dir_path = sys.argv[2]
        except IndexError:
            sys.stderr.write("pcap directory not found.\n")
            exit(1)

        generate_flows(pcap_dir_path)
        save_flows()
    if command == "filter_flows":
        try:
            with open("all_flows.pkl", "rb") as file:
                FLOWS = pickle.load(file)
                filter_flows()
        except FileNotFoundError:
            sys.stderr.write("all_flows.pkl not found.\n")
            exit(1)
    if command == "2_lvl_dep":
        try:
            with open("filtered_flows.pkl", "rb") as file:
                candidates = pickle.load(file)
                T_dep = 1  # seconds
                N_dep = 5
                S_dep_th = 0.5
                deps = extract_two_level_flow_dependencies(
                    candidates, T_dep, N_dep, S_dep_th
                )
                save_two_lvl_flow_dependencies(deps, T_dep, N_dep, S_dep_th)
        except FileNotFoundError:
            sys.stderr.write("filtered_flows.pkl not found.\n")
            exit(1)
    if command == "k_lvl_dep":
        # TODO exception handling
        k = int(sys.argv[2])
        two_lvl_flow_deps_path = sys.argv[3]
        S_dep_th = 0.5
        with open(two_lvl_flow_deps_path, "rb") as file:
            two_lvl_flow_deps = pickle.load(file)
            deps = find_k_lvl_flow_dependencies(two_lvl_flow_deps, k, S_dep_th)
        save_k_lvl_flow_dependencies(deps, k)
    if command == "compute_dist":
        # TODO exception handling
        k = int(sys.argv[2])
        k_lvl_flow_deps_path = sys.argv[3]
        with open(k_lvl_flow_deps_path, "rb") as file:
            k_lvl_flow_deps = pickle.load(file)
            dist_mat = compute_distance_matrix(k_lvl_flow_deps, k)
            save_distance_matrix(dist_mat)
            clustering(dist_mat)
