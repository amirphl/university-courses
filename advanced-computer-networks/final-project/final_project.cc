/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <bits/stdc++.h>
#include "ns3/core-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/network-module.h"
#include "ns3/applications-module.h"
#include "ns3/mobility-module.h"
#include "ns3/csma-module.h"
#include "ns3/internet-module.h"
#include "ns3/yans-wifi-helper.h"
#include "ns3/ssid.h"

using namespace ns3;
using namespace std;

NS_LOG_COMPONENT_DEFINE("FinalProject");

class Edge
{
public:
    int sourceIndex, sinkIndex;
    string network, mask;

    Edge(int sourceIndex, int sinkIndex, string network, string mask)
    {
        this->sourceIndex = sourceIndex;
        this->sinkIndex = sinkIndex;
        this->network = network;
        this->mask = mask;
    }
};

void fill_p2p_edges(vector<Edge> &edges)
{
    edges.push_back(Edge(0, 1, "192.168.1.0", "255.255.255.0"));
    edges.push_back(Edge(0, 2, "192.168.2.0", "255.255.255.0"));
    edges.push_back(Edge(0, 3, "192.168.3.0", "255.255.255.0"));
    edges.push_back(Edge(0, 4, "192.168.4.0", "255.255.255.0"));
    edges.push_back(Edge(1, 11, "192.168.5.0", "255.255.255.0"));
    edges.push_back(Edge(3, 31, "192.168.6.0", "255.255.255.0"));
}

void setup_p2p(NodeContainer &nodes,
               vector<NodeContainer> &links,
               vector<NetDeviceContainer> &devices,
               vector<Ipv4InterfaceContainer> &interfaces,
               unordered_map<int, Ptr<Node>> &indexToNode,
               vector<Edge> &edges)
{
    unordered_set<int> uniqueIndexes;

    for (Edge &e : edges)
    {
        uniqueIndexes.insert(e.sourceIndex);
        uniqueIndexes.insert(e.sinkIndex);
    }

    const int nP2P = uniqueIndexes.size();

    nodes.Create(nP2P);

    InternetStackHelper inetStackHelper;
    inetStackHelper.Install(nodes);

    PointToPointHelper p2pHelper;
    p2pHelper.SetDeviceAttribute("DataRate", StringValue("2Mbps")); // TODO
    p2pHelper.SetChannelAttribute("Delay", StringValue("30ms"));

    Ipv4AddressHelper ipv4Helper;

    int nextNodeCounter = 0;

    for (Edge &e : edges)
    {
        Ptr<Node> source, sink;

        if (indexToNode.find(e.sourceIndex) == indexToNode.end())
        {
            source = nodes.Get(nextNodeCounter++);
            indexToNode[e.sourceIndex] = source;
        }
        else
        {
            source = indexToNode[e.sourceIndex];
        }

        if (indexToNode.find(e.sinkIndex) == indexToNode.end())
        {
            sink = nodes.Get(nextNodeCounter++);
            indexToNode[e.sinkIndex] = sink;
        }
        else
        {
            sink = indexToNode[e.sinkIndex];
        }

        NodeContainer link = NodeContainer(source, sink);
        NetDeviceContainer device = p2pHelper.Install(link);

        ipv4Helper.SetBase(e.network.c_str(), e.mask.c_str());
        Ipv4InterfaceContainer interface = ipv4Helper.Assign(device);

        links.push_back(link);
        devices.push_back(device);
        interfaces.push_back(interface);
    }
}

void setup_csma(NodeContainer &nodes,
                NetDeviceContainer &device,
                Ipv4InterfaceContainer &interface,
                Ptr<Node> gateway,
                const char *network,
                const char *mask,
                int nCsma)
{
    nodes.Create(nCsma);
    InternetStackHelper inetStackHelper;
    inetStackHelper.Install(nodes);

    nodes.Add(gateway);

    CsmaHelper csmaHelper;
    csmaHelper.SetChannelAttribute("DataRate", StringValue("100Mbps")); // TODO
    csmaHelper.SetChannelAttribute("Delay", TimeValue(NanoSeconds(6560)));

    device = csmaHelper.Install(nodes);

    Ipv4AddressHelper ipv4Helper;
    ipv4Helper.SetBase(network, mask);
    interface = ipv4Helper.Assign(device);
}

int main(int argc, char *argv[])
{
    bool verbose = true;
    uint32_t nCsma = 3;
    uint32_t nWifi = 3;
    bool tracing = false;

    CommandLine cmd;
    cmd.AddValue("nCsma", "Number of \"extra\" CSMA nodes/devices", nCsma);
    cmd.AddValue("nWifi", "Number of wifi STA devices", nWifi);
    cmd.AddValue("verbose", "Tell echo applications to log if true", verbose);
    cmd.AddValue("tracing", "Enable pcap tracing", tracing);

    cmd.Parse(argc, argv);

    // The underlying restriction of 18 is due to the grid position
    // allocator's configuration; the grid layout will exceed the
    // bounding box if more than 18 nodes are provided.
    if (nWifi > 18)
    {
        std::cout << "nWifi should be 18 or less; otherwise grid layout exceeds the bounding box" << std::endl;
        return 1;
    }

    if (verbose)
    {
        LogComponentEnable("UdpEchoClientApplication", LOG_LEVEL_INFO);
        LogComponentEnable("UdpEchoServerApplication", LOG_LEVEL_INFO);
    }

    NodeContainer p2pNodes, northCsmaNodes, southCsmaNodes;
    vector<NodeContainer> p2pLinks;
    vector<NetDeviceContainer> p2pDevices;
    vector<Ipv4InterfaceContainer> p2pInterfaces;
    NetDeviceContainer northCsmaDevice, southCsmaDevice;
    Ipv4InterfaceContainer northCsmaInterface, southCsmaInterface;
    unordered_map<int, Ptr<Node>> indexToNode;
    vector<Edge> edges;

    fill_p2p_edges(edges);

    setup_p2p(p2pNodes, p2pLinks, p2pDevices, p2pInterfaces, indexToNode, edges);

    Ptr<Node> n11 = indexToNode[11];
    Ptr<Node> n31 = indexToNode[31];

    setup_csma(northCsmaNodes, northCsmaDevice, northCsmaInterface, n11, "10.1.2.0", "255.255.255.0", 2);

    setup_csma(southCsmaNodes, southCsmaDevice, southCsmaInterface, n31, "10.1.5.0", "255.255.255.0", 2);

    Simulator::Run();
    Simulator::Destroy();
    return 0;
}
