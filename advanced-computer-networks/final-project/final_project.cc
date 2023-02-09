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

class OnOffScenario
{
public:
    int sourceIndex, sinkIndex;
    StringValue onTime, offTime;
    DataRate dataRate;
    Time start, end;

    OnOffScenario(int sourceIndex, int sinkIndex,
                  StringValue onTime, StringValue offTime,
                  DataRate dataRate,
                  Time start, Time end)
    {
        this->sourceIndex = sourceIndex;
        this->sinkIndex = sinkIndex;
        this->onTime = onTime;
        this->offTime = offTime;
        this->dataRate = dataRate;
        this->start = start;
        this->end = end;
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

void fill_on_off_scenarioes(vector<OnOffScenario> &scenarios)
{
    scenarios.push_back(OnOffScenario(0, 1,
                                       StringValue("ns3::ConstantRandomVariable[Constant=1]"),
                                       StringValue("ns3::ConstantRandomVariable[Constant=0]"),
                                       DataRate("1500kbps"),
                                       Seconds(2), Seconds(30)));
    scenarios.push_back(OnOffScenario(0, 3,
                                       StringValue("ns3::ConstantRandomVariable[Constant=1]"),
                                       StringValue("ns3::ConstantRandomVariable[Constant=0]"),
                                       DataRate("2500kbps"),
                                       Seconds(5), Seconds(25)));
    scenarios.push_back(OnOffScenario(0, 31,
                                       StringValue("ns3::ConstantRandomVariable[Constant=2]"),
                                       StringValue("ns3::ConstantRandomVariable[Constant=1]"),
                                       DataRate("4096bps"),
                                       Seconds(2), Seconds(30)));
    scenarios.push_back(OnOffScenario(0, 11,
                                       StringValue("ns3::ConstantRandomVariable[Constant=2]"),
                                       StringValue("ns3::ConstantRandomVariable[Constant=1]"),
                                       DataRate("4096bps"),
                                       Seconds(2), Seconds(30)));
    scenarios.push_back(OnOffScenario(3, 22,
                                       StringValue("ns3::ConstantRandomVariable[Constant=1]"),
                                       StringValue("ns3::ConstantRandomVariable[Constant=2]"),
                                       DataRate("4096bps"),
                                       Seconds(0), Seconds(30)));
    scenarios.push_back(OnOffScenario(1, 42,
                                       StringValue("ns3::ConstantRandomVariable[Constant=2]"),
                                       StringValue("ns3::ConstantRandomVariable[Constant=1]"),
                                       DataRate("4096bps"),
                                       Seconds(0), Seconds(30)));
}
void setup_mobility(MobilityHelper &mobilityHelper)
{
    mobilityHelper.SetPositionAllocator("ns3::GridPositionAllocator",
                                        "MinX", DoubleValue(0.0),
                                        "MinY", DoubleValue(0.0),
                                        "DeltaX", DoubleValue(5.0),
                                        "DeltaY", DoubleValue(10.0),
                                        "GridWidth", UintegerValue(3),
                                        "LayoutType", StringValue("RowFirst"));
    mobilityHelper.SetMobilityModel("ns3::ConstantPositionMobilityModel");
}

unordered_map<int, Ptr<Node>> *setup_p2p(NodeContainer &nodes,
                                         vector<NodeContainer> &links,
                                         vector<NetDeviceContainer> &devices,
                                         vector<Ipv4InterfaceContainer> &interfaces,
                                         vector<Edge> &edges,
                                         StringValue dataRate,
                                         TimeValue delay)
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
    p2pHelper.SetDeviceAttribute("DataRate", dataRate);
    p2pHelper.SetChannelAttribute("Delay", delay);

    Ipv4AddressHelper ipv4Helper;

    unordered_map<int, Ptr<Node>> *indexToNode = new unordered_map<int, Ptr<Node>>();
    int nextNodeCounter = 0;

    for (Edge &e : edges)
    {
        Ptr<Node> source, sink;

        if (indexToNode->find(e.sourceIndex) == indexToNode->end())
        {
            source = nodes.Get(nextNodeCounter++);
            indexToNode->insert({e.sourceIndex, source});
        }
        else
        {
            source = indexToNode->at(e.sourceIndex);
        }

        if (indexToNode->find(e.sinkIndex) == indexToNode->end())
        {
            sink = nodes.Get(nextNodeCounter++);
            indexToNode->insert({e.sinkIndex, sink});
        }
        else
        {
            sink = indexToNode->at(e.sinkIndex);
        }

        NodeContainer link = NodeContainer(source, sink);
        NetDeviceContainer device = p2pHelper.Install(link);

        ipv4Helper.SetBase(e.network.c_str(), e.mask.c_str());
        Ipv4InterfaceContainer interface = ipv4Helper.Assign(device);

        links.push_back(link);
        devices.push_back(device);
        interfaces.push_back(interface);
    }

    return indexToNode;
}

void setup_csma(NodeContainer &nodes,
                Ptr<Node> &gateway,
                NetDeviceContainer &device,
                Ipv4InterfaceContainer &interface,
                StringValue dataRate,
                TimeValue delay,
                string network,
                string mask,
                int nCsma)
{
    nodes.Create(nCsma);
    InternetStackHelper inetStackHelper;
    inetStackHelper.Install(nodes);

    nodes.Add(gateway);

    CsmaHelper csmaHelper;
    csmaHelper.SetChannelAttribute("DataRate", dataRate);
    csmaHelper.SetChannelAttribute("Delay", delay);

    device = csmaHelper.Install(nodes);

    Ipv4AddressHelper ipv4Helper;
    ipv4Helper.SetBase(network.c_str(), mask.c_str());
    interface = ipv4Helper.Assign(device);
}

void setup_wifi(NodeContainer &stationNodes,
                Ptr<Node> &accessPointNode,
                NetDeviceContainer &stationDevice,
                NetDeviceContainer &accessPointDevice,
                Ipv4InterfaceContainer &stationInterface,
                Ipv4InterfaceContainer &accessPointInterface,
                MobilityHelper &mobilityHelper,
                Ssid ssid,
                string network,
                string mask,
                int nWifi)
{
    stationNodes.Create(nWifi);

    YansWifiChannelHelper channel = YansWifiChannelHelper::Default();
    YansWifiPhyHelper phy = YansWifiPhyHelper::Default();
    phy.SetChannel(channel.Create());

    WifiHelper wifiHelper;
    wifiHelper.SetRemoteStationManager("ns3::AarfWifiManager");

    WifiMacHelper macHelper;
    macHelper.SetType("ns3::StaWifiMac", "Ssid", SsidValue(ssid),
                      "ActiveProbing", BooleanValue(false)); // TODO

    stationDevice = wifiHelper.Install(phy, macHelper, stationNodes);

    macHelper.SetType("ns3::ApWifiMac", "Ssid", SsidValue(ssid));

    accessPointDevice = wifiHelper.Install(phy, macHelper, accessPointNode);

    InternetStackHelper stack;
    stack.Install(stationNodes);
    // stack.Install(accessPointNode);

    Ipv4AddressHelper ipv4Helper;
    ipv4Helper.SetBase(network.c_str(), mask.c_str());
    stationInterface = ipv4Helper.Assign(stationDevice);
    accessPointInterface = ipv4Helper.Assign(accessPointDevice);

    mobilityHelper.Install(stationNodes);
    mobilityHelper.Install(accessPointNode);
}

void setup_on_off_application()
{
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

    StringValue p2pDataRate("2Mbps");
    TimeValue p2pDelay(MilliSeconds(30));
    StringValue northCsmaDataRate("100Mbps");
    TimeValue northCsmaDelay(NanoSeconds(5600));
    StringValue southCsmaDataRate("200Mbps");
    TimeValue southCsmaDelay(NanoSeconds(6560));

    double simulationPeriod = 30.0;

    NodeContainer p2pNodes, northCsmaNodes, southCsmaNodes, northWifiNodes, southWifiNodes;
    vector<NodeContainer> p2pLinks;
    vector<NetDeviceContainer> p2pDevices;
    vector<Ipv4InterfaceContainer> p2pInterfaces;
    NetDeviceContainer northCsmaDevice,
        southCsmaDevice,
        northStationDevice,
        northAccessPointDevice,
        southStationDevice,
        southAccessPointDevice;
    Ipv4InterfaceContainer northCsmaInterface,
        southCsmaInterface,
        northStationInterface,
        northAccessPointInterface,
        southStationInterface,
        southAccessPointInterface;
    MobilityHelper mobilityHelper;

    vector<OnOffScenario> scenarios;
    vector<Edge> edges;

    fill_on_off_scenarioes(scenarios);
    fill_p2p_edges(edges);
    setup_mobility(mobilityHelper);

    unordered_map<int, Ptr<Node>> *indexToNode = setup_p2p(p2pNodes,
                                                           p2pLinks,
                                                           p2pDevices,
                                                           p2pInterfaces,
                                                           edges,
                                                           p2pDataRate,
                                                           p2pDelay);

    Ptr<Node> n11 = indexToNode->at(11);
    Ptr<Node> n31 = indexToNode->at(31);
    Ptr<Node> n2 = indexToNode->at(2);
    Ptr<Node> n4 = indexToNode->at(4);

    setup_csma(northCsmaNodes,
               n11,
               northCsmaDevice,
               northCsmaInterface,
               northCsmaDataRate,
               northCsmaDelay,
               "10.1.2.0",
               "255.255.255.0",
               2);

    setup_csma(southCsmaNodes,
               n31,
               southCsmaDevice,
               southCsmaInterface,
               southCsmaDataRate,
               southCsmaDelay,
               "10.1.5.0",
               "255.255.255.0",
               2);

    setup_wifi(northWifiNodes,
               n2,
               northStationDevice,
               northAccessPointDevice,
               northStationInterface,
               northAccessPointInterface,
               mobilityHelper,
               Ssid("ns-n2-ssid"),
               "10.1.3.0",
               "255.255.255.0",
               2);

    setup_wifi(southWifiNodes,
               n4,
               southStationDevice,
               southAccessPointDevice,
               southStationInterface,
               southAccessPointInterface,
               mobilityHelper,
               Ssid("ns-n4-ssid"),
               "10.1.4.0",
               "255.255.255.0",
               2);

    Simulator::Stop(Seconds(simulationPeriod));
    Simulator::Run();
    Simulator::Destroy();
    return 0;
}
