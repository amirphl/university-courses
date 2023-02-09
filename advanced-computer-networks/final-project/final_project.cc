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
#include "ns3/flow-monitor-helper.h"
#include "ns3/ipv4-global-routing-helper.h"
#include "ns3/netanim-module.h"
#include "ns3/stats-module.h"
#include "ns3/trace-helper.h"

using namespace ns3;
using namespace std;

NS_LOG_COMPONENT_DEFINE("FinalProject");

class Edge
{
public:
    Ptr<Node> source, sink;
    string network, mask;

    Edge(Ptr<Node> source, Ptr<Node> sink, string network, string mask)
    {
        this->source = source;
        this->sink = sink;
        this->network = network;
        this->mask = mask;
    }
};

class OnOffScenario
{
public:
    Ptr<Node> source;
    Ptr<Node> sink;
    Ipv4Address sinkIP;
    uint16_t sinkPort;
    StringValue onTime, offTime;
    DataRate dataRate;
    Time start, end;

    OnOffScenario(
        Ptr<Node> source,
        Ptr<Node> sink,
        Ipv4Address sinkIP,
        uint16_t sinkPort,
        StringValue onTime,
        StringValue offTime,
        DataRate dataRate,
        Time start,
        Time end)
    {
        this->source = source;
        this->sink = sink;
        this->sinkIP = sinkIP;
        this->sinkPort = sinkPort,
        this->onTime = onTime;
        this->offTime = offTime;
        this->dataRate = dataRate;
        this->start = start;
        this->end = end;
    }
};

void create_nodes(
    NodeContainer &p2pNodes,
    NodeContainer &northCsmaNodes,
    NodeContainer &southCsmaNodes,
    NodeContainer &northStationNodes,
    NodeContainer &southStationNodes,
    Ptr<Node> &northCsmaGateWay,
    Ptr<Node> &southCsmaGateWay,
    Ptr<Node> &northAccessPoint,
    Ptr<Node> &southAccessPoint,
    unordered_map<int, Ptr<Node>> &indexToNode)
{
    p2pNodes.Create(7);
    northCsmaNodes.Create(2);
    southCsmaNodes.Create(2);
    northStationNodes.Create(2);
    southStationNodes.Create(2);

    indexToNode.insert({
        {0, p2pNodes.Get(0)},
        {1, p2pNodes.Get(1)},
        {2, p2pNodes.Get(2)},
        {3, p2pNodes.Get(3)},
        {4, p2pNodes.Get(4)},
        {11, p2pNodes.Get(5)},
        {31, p2pNodes.Get(6)},
        {12, northCsmaNodes.Get(0)},
        {13, northCsmaNodes.Get(1)},
        {32, southCsmaNodes.Get(0)},
        {33, southCsmaNodes.Get(1)},
        {21, northStationNodes.Get(0)},
        {22, northStationNodes.Get(1)},
        {41, southStationNodes.Get(0)},
        {42, southStationNodes.Get(1)},
    });

    northCsmaGateWay = indexToNode[11];
    southCsmaGateWay = indexToNode[31];
    northAccessPoint = indexToNode[2];
    southAccessPoint = indexToNode[4];

    InternetStackHelper inetStackHelper;
    inetStackHelper.Install(p2pNodes);
    inetStackHelper.Install(northCsmaNodes);
    inetStackHelper.Install(southCsmaNodes);
    inetStackHelper.Install(northStationNodes);
    inetStackHelper.Install(southStationNodes);
}

void create_edges(vector<Edge> &edges, unordered_map<int, Ptr<Node>> &indexToNode)
{
    edges.push_back(
        Edge(
            indexToNode[0],
            indexToNode[1],
            "192.168.1.0",
            "255.255.255.0"));
    edges.push_back(
        Edge(
            indexToNode[0],
            indexToNode[2],
            "192.168.2.0",
            "255.255.255.0"));
    edges.push_back(
        Edge(indexToNode[0],
             indexToNode[3],
             "192.168.3.0",
             "255.255.255.0"));
    edges.push_back(
        Edge(
            indexToNode[0],
            indexToNode[4],
            "192.168.4.0",
            "255.255.255.0"));
    edges.push_back(
        Edge(
            indexToNode[1],
            indexToNode[11],
            "192.168.5.0",
            "255.255.255.0"));
    edges.push_back(
        Edge(
            indexToNode[3],
            indexToNode[31],
            "192.168.6.0",
            "255.255.255.0"));
}

void fill_on_off_scenarios(
    vector<Ipv4InterfaceContainer> &p2pInterfaces,
    vector<Ipv4InterfaceContainer> &northCsmaInterfaces,
    vector<Ipv4InterfaceContainer> &southCsmaInterfaces,
    vector<Ipv4InterfaceContainer> &northWifiInterfaces,
    vector<Ipv4InterfaceContainer> &southWifiInterfaces,
    unordered_map<int, Ptr<Node>> &indexToNode,
    vector<OnOffScenario> &scenarios)
{
    scenarios.push_back(
        OnOffScenario(
            indexToNode[0],
            indexToNode[1],
            p2pInterfaces[0].GetAddress(1), // TODO Find a better way to do that.
            1443,
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            StringValue("ns3::ConstantRandomVariable[Constant=0]"),
            DataRate("1500kbps"),
            Seconds(2),
            Seconds(30)));

    scenarios.push_back(
        OnOffScenario(
            indexToNode[0],
            indexToNode[3],
            p2pInterfaces[2].GetAddress(1), // TODO Same as above.
            2443,
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            StringValue("ns3::ConstantRandomVariable[Constant=0]"),
            DataRate("2500kbps"),
            Seconds(5),
            Seconds(25)));

    scenarios.push_back(
        OnOffScenario(
            indexToNode[0],
            indexToNode[31],
            p2pInterfaces[5].GetAddress(1), // TODO Same as above.
            3443,
            StringValue("ns3::ConstantRandomVariable[Constant=2]"),
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            DataRate("4096bps"),
            Seconds(2),
            Seconds(30)));

    scenarios.push_back(
        OnOffScenario(
            indexToNode[0],
            indexToNode[11],
            p2pInterfaces[4].GetAddress(1), // TODO Same as above.
            4443,
            StringValue("ns3::ConstantRandomVariable[Constant=2]"),
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            DataRate("4096bps"),
            Seconds(2),
            Seconds(30)));

    cout << "-----\n";
    northWifiInterfaces[0].GetAddress(0).Print(cout);
    cout << "\n";
    northWifiInterfaces[0].GetAddress(1).Print(cout);
    cout << "\n";

    scenarios.push_back(
        OnOffScenario(
            indexToNode[3],
            indexToNode[22],
            northWifiInterfaces[0].GetAddress(1), // TODO Same as above.
            5443,
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            StringValue("ns3::ConstantRandomVariable[Constant=2]"),
            DataRate("4096bps"),
            Seconds(0),
            Seconds(30)));

    southWifiInterfaces[0].GetAddress(0).Print(cout);
    cout << "\n";
    southWifiInterfaces[0].GetAddress(1).Print(cout);
    cout << "\n";

    scenarios.push_back(
        OnOffScenario(
            indexToNode[1],
            indexToNode[42],
            southWifiInterfaces[0].GetAddress(1), // TODO Same as above.
            6443,
            StringValue("ns3::ConstantRandomVariable[Constant=2]"),
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            DataRate("4096bps"),
            Seconds(0),
            Seconds(30)));

    southCsmaInterfaces[0].GetAddress(0).Print(cout);
    cout << "\n";
    southCsmaInterfaces[0].GetAddress(1).Print(cout);
    cout << "\n";
    cout << "-----\n";

    scenarios.push_back(
        OnOffScenario(
            indexToNode[2],
            indexToNode[33],
            southCsmaInterfaces[0].GetAddress(1), // TODO Same as above.
            7443,
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            StringValue("ns3::ConstantRandomVariable[Constant=1]"),
            DataRate("4096bps"),
            Seconds(0),
            Seconds(30)));
}

void setup_on_off_application(
    vector<OnOffScenario> &scenarios,
    vector<ApplicationContainer> &sourceApps,
    vector<ApplicationContainer> &sinkApps)
{
    for (OnOffScenario &s : scenarios)
    {
        OnOffHelper onoff("ns3::UdpSocketFactory", Address(InetSocketAddress(s.sinkIP, s.sinkPort)));
        onoff.SetAttribute("OnTime", s.onTime);
        onoff.SetAttribute("OffTime", s.offTime);
        onoff.SetConstantRate(s.dataRate);
        ApplicationContainer sourceApp = onoff.Install(s.source);
        sourceApp.Start(s.start);
        sourceApp.Stop(s.end);

        PacketSinkHelper sinkHelper("ns3::UdpSocketFactory", Address(InetSocketAddress(Ipv4Address::GetAny(), s.sinkPort)));
        ApplicationContainer sinkApp = sinkHelper.Install(s.sink);
        sinkApp.Start(s.start);
        sinkApp.Stop(s.end);

        sourceApps.push_back(sourceApp);
        sinkApps.push_back(sinkApp);
    }
}

double time_snt, time_rcv;

void udpEchoClientTxTrace(string context, Ptr<const Packet> packet)
{
    time_snt = Now().GetSeconds();
    cout << "context, " << context << "\n";
    cout << "udp echo client Tx Trace, " << time_snt << "\n";
    cout << "-----\n";
}

void udpEchoClientRxTrace(string context, Ptr<const Packet> packet)
{
    time_rcv = Now().GetSeconds();
    cout << "context, " << context << "\n";
    cout << "udp echo client Rx Trace, " << time_rcv << "\n";
    cout << "RTT = " << time_rcv - time_snt << " seconds\n";
    cout << "-----\n";
}

void setup_udp_echo_application(
    vector<Ipv4InterfaceContainer> &p2pInterfaces,
    vector<Ipv4InterfaceContainer> &northCsmaInterfaces,
    vector<Ipv4InterfaceContainer> &southCsmaInterfaces,
    vector<Ipv4InterfaceContainer> &northWifiInterfaces,
    vector<Ipv4InterfaceContainer> &southWifiInterfaces,
    unordered_map<int, Ptr<Node>> &indexToNode,
    vector<ApplicationContainer> &udpClientApps,
    vector<ApplicationContainer> &udpServerApps)
{
    uint16_t port = 5432;
    Ptr<Node> n42 = indexToNode[42];
    Time start = Seconds(1.0);
    Time end = Seconds(10.0);

    UdpEchoServerHelper echoServerHelper(port);
    ApplicationContainer serverApp = echoServerHelper.Install(n42);
    serverApp.Start(start);
    serverApp.Stop(end);
    udpServerApps.push_back(serverApp);

    cout << "-----\n";
    southWifiInterfaces[0].GetAddress(0).Print(cout);
    cout << "\n";
    southWifiInterfaces[0].GetAddress(1).Print(cout);
    cout << "\n";
    cout << "-----\n";

    UdpEchoClientHelper echoClientHelper(southWifiInterfaces[0].GetAddress(1), port);
    echoClientHelper.SetAttribute("MaxPackets", UintegerValue(1));
    echoClientHelper.SetAttribute("Interval", TimeValue(Seconds(1.0)));
    echoClientHelper.SetAttribute("PacketSize", UintegerValue(1024));

    Ptr<Node> n13 = indexToNode[13];
    ApplicationContainer clientApp = echoClientHelper.Install(n13);
    clientApp.Start(start);
    clientApp.Stop(end);
    udpClientApps.push_back(clientApp);

    string txPath = "/NodeList/" + to_string(n13->GetId()) + "/ApplicationList/*/$ns3::UdpEchoClient/Tx";
    string rxPath = "/NodeList/" + to_string(n13->GetId()) + "/ApplicationList/*/$ns3::UdpEchoClient/Rx";
    Config::Connect(txPath, MakeCallback(&udpEchoClientTxTrace));
    Config::Connect(rxPath, MakeCallback(&udpEchoClientRxTrace));
}

void setup_p2p(
    NodeContainer &nodes,
    vector<NodeContainer> &links,
    vector<NetDeviceContainer> &devices,
    vector<Ipv4InterfaceContainer> &interfaces,
    vector<Edge> &edges,
    StringValue dataRate,
    TimeValue delay)
{
    PointToPointHelper p2pHelper;
    p2pHelper.SetDeviceAttribute("DataRate", dataRate);
    p2pHelper.SetChannelAttribute("Delay", delay);

    Ipv4AddressHelper ipv4Helper;

    for (Edge &e : edges)
    {
        NodeContainer link = NodeContainer(e.source, e.sink);
        NetDeviceContainer device = p2pHelper.Install(link);

        ipv4Helper.SetBase(e.network.c_str(), e.mask.c_str());
        Ipv4InterfaceContainer interface = ipv4Helper.Assign(device);

        links.push_back(link);
        devices.push_back(device);
        interfaces.push_back(interface);
    }
}

void setup_csma(
    NodeContainer &nodes,
    Ptr<Node> &gateway,
    vector<NetDeviceContainer> &devices,
    vector<Ipv4InterfaceContainer> &interfaces,
    StringValue dataRate,
    TimeValue delay,
    string network,
    string mask)
{
    nodes.Add(gateway);

    CsmaHelper csmaHelper;
    csmaHelper.SetChannelAttribute("DataRate", dataRate);
    csmaHelper.SetChannelAttribute("Delay", delay);

    NetDeviceContainer device = csmaHelper.Install(nodes);

    Ipv4AddressHelper ipv4Helper;
    ipv4Helper.SetBase(network.c_str(), mask.c_str());
    Ipv4InterfaceContainer interface = ipv4Helper.Assign(device);

    devices.push_back(device);
    interfaces.push_back(interface);
}

void setup_mobility(MobilityHelper &mobilityHelper)
{
    mobilityHelper.SetPositionAllocator(
        "ns3::GridPositionAllocator",
        "MinX", DoubleValue(0.0),
        "MinY", DoubleValue(0.0),
        "DeltaX", DoubleValue(5.0),
        "DeltaY", DoubleValue(10.0),
        "GridWidth", UintegerValue(3),
        "LayoutType", StringValue("RowFirst"));
    mobilityHelper.SetMobilityModel("ns3::ConstantPositionMobilityModel");
}

void setup_wifi(
    NodeContainer &stationNodes,
    Ptr<Node> &accessPointNode,
    vector<NetDeviceContainer> &devices,
    vector<Ipv4InterfaceContainer> &interfaces,
    MobilityHelper &mobilityHelper,
    Ssid ssid,
    string network,
    string mask)
{
    YansWifiChannelHelper channel = YansWifiChannelHelper::Default();
    YansWifiPhyHelper phy = YansWifiPhyHelper::Default();
    phy.SetChannel(channel.Create());

    WifiHelper wifiHelper;
    wifiHelper.SetRemoteStationManager("ns3::AarfWifiManager");

    WifiMacHelper macHelper;
    macHelper.SetType("ns3::StaWifiMac", "Ssid", SsidValue(ssid),
                      "ActiveProbing", BooleanValue(false)); // TODO

    NetDeviceContainer stationDevice = wifiHelper.Install(phy, macHelper, stationNodes);

    macHelper.SetType("ns3::ApWifiMac", "Ssid", SsidValue(ssid));

    NetDeviceContainer accessPointDevice = wifiHelper.Install(phy, macHelper, accessPointNode);

    Ipv4AddressHelper ipv4Helper;
    ipv4Helper.SetBase(network.c_str(), mask.c_str());
    Ipv4InterfaceContainer stationInterface = ipv4Helper.Assign(stationDevice);
    Ipv4InterfaceContainer accessPointInterface = ipv4Helper.Assign(accessPointDevice);

    mobilityHelper.Install(stationNodes);
    mobilityHelper.Install(accessPointNode);

    devices.push_back(stationDevice);
    devices.push_back(accessPointDevice);
    interfaces.push_back(stationInterface);
    interfaces.push_back(accessPointInterface);
}

void setup_link_failure(unordered_map<int, Ptr<Node>> &indexToNode)
{
    Ptr<Node> n0 = indexToNode[0];
    Ptr<Node> n1 = indexToNode[1];
    Ptr<Node> n2 = indexToNode[2];
    Ptr<Node> n3 = indexToNode[3];
    Ptr<Ipv4> n0_ipv4 = n0->GetObject<Ipv4>();
    Ptr<Ipv4> n1_ipv4 = n1->GetObject<Ipv4>();
    Ptr<Ipv4> n2_ipv4 = n2->GetObject<Ipv4>();
    Ptr<Ipv4> n3_ipv4 = n3->GetObject<Ipv4>();

    uint32_t n0n1Index = 1;
    uint32_t n1n0Index = 1;
    uint32_t n0n2Index = 2;
    uint32_t n2n0Index = 1;
    uint32_t n0n3Index = 3;
    uint32_t n3n0Index = 1;

    cout << "-------\n";
    cout << "Remove n0 --- > n1: " << (n0_ipv4->GetAddress(n0n1Index, 0)).GetLocal() << "\n";
    cout << "Remove n1 --- > n0: " << (n1_ipv4->GetAddress(n1n0Index, 0)).GetLocal() << "\n";
    cout << "Remove n0 --- > n2: " << (n0_ipv4->GetAddress(n0n2Index, 0)).GetLocal() << "\n";
    cout << "Remove n2 --- > n0: " << (n2_ipv4->GetAddress(n2n0Index, 0)).GetLocal() << "\n";
    cout << "Remove n0 --- > n3: " << (n0_ipv4->GetAddress(n0n3Index, 0)).GetLocal() << "\n";
    cout << "Remove n3 --- > n0: " << (n3_ipv4->GetAddress(n3n0Index, 0)).GetLocal() << "\n";
    cout << "-------\n";

    Simulator::Schedule(Seconds(5), &Ipv4::SetDown, n0_ipv4, n0n1Index);
    Simulator::Schedule(Seconds(10), &Ipv4::SetUp, n0_ipv4, n0n1Index);
    Simulator::Schedule(Seconds(5), &Ipv4::SetDown, n1_ipv4, n1n0Index);
    Simulator::Schedule(Seconds(10), &Ipv4::SetUp, n1_ipv4, n1n0Index);

    Simulator::Schedule(Seconds(10), &Ipv4::SetDown, n0_ipv4, n0n2Index);
    Simulator::Schedule(Seconds(12), &Ipv4::SetUp, n0_ipv4, n0n2Index);
    Simulator::Schedule(Seconds(10), &Ipv4::SetDown, n2_ipv4, n2n0Index);
    Simulator::Schedule(Seconds(12), &Ipv4::SetUp, n2_ipv4, n2n0Index);

    Simulator::Schedule(Seconds(15), &Ipv4::SetDown, n0_ipv4, n0n3Index);
    Simulator::Schedule(Seconds(18), &Ipv4::SetUp, n0_ipv4, n0n3Index);
    Simulator::Schedule(Seconds(15), &Ipv4::SetDown, n3_ipv4, n3n0Index);
    Simulator::Schedule(Seconds(18), &Ipv4::SetUp, n3_ipv4, n3n0Index);
}

int main(int argc, char *argv[])
{
    bool verbose = true;
    bool tracing = true;

    CommandLine cmd;
    cmd.AddValue("verbose", "Tell echo applications to log if true", verbose);
    cmd.AddValue("tracing", "Enable pcap tracing", tracing);

    cmd.Parse(argc, argv);

    if (verbose)
    {
        LogComponentEnable("UdpEchoClientApplication", LOG_LEVEL_INFO);
        LogComponentEnable("UdpEchoServerApplication", LOG_LEVEL_INFO);
    }

    StringValue p2pDataRate("2Mbps");
    TimeValue p2pDelay(MilliSeconds(30));
    StringValue northCsmaDataRate("100Mbps");
    TimeValue northCsmaDelay(NanoSeconds(5600));
    StringValue southCsmaDataRate("200Mbps");
    TimeValue southCsmaDelay(NanoSeconds(6560));

    double simulationPeriod = 30.0;

    NodeContainer p2pNodes,
        northCsmaNodes,
        southCsmaNodes,
        northStationNodes,
        southStationNodes;

    Ptr<Node> northCsmaGateway,
        southCsmaGateway,
        northAccessPoint,
        southAccessPoint;

    vector<NodeContainer> p2pLinks;

    vector<NetDeviceContainer> p2pDevices,
        northCsmaDevices,
        southCsmaDevices,
        northWifiDevices,
        southWifiDevices;

    vector<Ipv4InterfaceContainer> p2pInterfaces,
        northCsmaInterfaces,
        southCsmaInterfaces,
        northWifiInterfaces,
        southWifiInterfaces;

    MobilityHelper mobilityHelper;

    vector<Edge> edges;
    vector<OnOffScenario> scenarios;
    vector<ApplicationContainer> sourceApps;
    vector<ApplicationContainer> sinkApps;
    vector<ApplicationContainer> udpClientApps;
    vector<ApplicationContainer> udpServerApps;
    unordered_map<int, Ptr<Node>> indexToNode;

    create_nodes(p2pNodes,
                 northCsmaNodes,
                 southCsmaNodes,
                 northStationNodes,
                 southStationNodes,
                 northCsmaGateway,
                 southCsmaGateway,
                 northAccessPoint,
                 southAccessPoint,
                 indexToNode);
    create_edges(edges, indexToNode);

    setup_p2p(p2pNodes,
              p2pLinks,
              p2pDevices,
              p2pInterfaces,
              edges,
              p2pDataRate,
              p2pDelay);

    setup_csma(northCsmaNodes,
               northCsmaGateway,
               northCsmaDevices,
               northCsmaInterfaces,
               northCsmaDataRate,
               northCsmaDelay,
               "10.1.2.0",
               "255.255.255.0");

    setup_csma(southCsmaNodes,
               southCsmaGateway,
               southCsmaDevices,
               southCsmaInterfaces,
               southCsmaDataRate,
               southCsmaDelay,
               "10.1.5.0",
               "255.255.255.0");

    setup_mobility(mobilityHelper);

    setup_wifi(northStationNodes,
               northAccessPoint,
               northWifiDevices,
               northWifiInterfaces,
               mobilityHelper,
               Ssid("ns-n2-ssid"),
               "10.1.3.0",
               "255.255.255.0");

    setup_wifi(southStationNodes,
               southAccessPoint,
               southWifiDevices,
               southWifiInterfaces,
               mobilityHelper,
               Ssid("ns-n4-ssid"),
               "10.1.4.0",
               "255.255.255.0");

    fill_on_off_scenarios(p2pInterfaces,
                          northCsmaInterfaces,
                          southCsmaInterfaces,
                          northWifiInterfaces,
                          southWifiInterfaces,
                          indexToNode,
                          scenarios);

    setup_on_off_application(scenarios, sourceApps, sinkApps);

    setup_udp_echo_application(p2pInterfaces,
                               northCsmaInterfaces,
                               southCsmaInterfaces,
                               northWifiInterfaces,
                               southWifiInterfaces,
                               indexToNode,
                               udpClientApps,
                               udpServerApps);

    setup_link_failure(indexToNode);

    Ipv4GlobalRoutingHelper::PopulateRoutingTables();

    Simulator::Stop(Seconds(simulationPeriod));
    Simulator::Run();
    Simulator::Destroy();
    return 0;
}
