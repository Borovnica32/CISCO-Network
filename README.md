# Network Infrastructure Project

This project demonstrates how to design, implement, and maintain a structured network using Windows Server, RADIUS, Active Directory (AD), and Network Policy Server (NPS).



The hardware used in this project can be found in:

/CISCO-omrezje-master/Hardware



The network topology is located at:

/CISCO-omrezje-master/Topologija



# Overview

The network consists of two Cisco routers, two Cisco switches, and a MikroTik router used as a Wi-Fi access point. For administration, a Windows 10 Server is used to run AD, RADIUS, and NPS services.



Active Directory currently contains two groups: NetWatch (network administrators) and regular users. RADIUS and NPS are used together to authenticate and authorize members of the NetWatch group when accessing Cisco devices. Access is restricted so that NetWatch users can connect via SSH only from designated management network segments (see network topology).



# Authentication and Authorization

Each Cisco device is registered on the RADIUS server with a pre-shared key. The devices are configured to communicate with the RADIUS server using AAA (authentication, authorization, and accounting), specifically with commands such as "aaa authentication", "aaa authorization", and "aaa group server radius".



Each device also has a fallback local account in case the RADIUS server becomes unavailable.



SSH access is restricted using access control lists. Only users from management network segments can connect, and only to specific IP addresses on each device (loopback interfaces for routers or management IPs for switches).



# Network Design

Each router has a loopback interface and multiple VLANs configured. OSPF is used for routing between networks, and there is a redundant connection between the two routers.



Switches do not use loopback interfaces. Instead, they use the second IP address from VLAN 100, which is designated as the management VLAN. Trunk ports are configured on switches to allow VLAN traffic between different network segments.



Currently, the network includes three VLANs: VLAN 10, VLAN 20, and VLAN 100.



[Network Topology](./Topologija/Diagram%20Cisco%20omprezja%20IPv4.png)



# Wireless and DHCP

The main router (R1) has a configured DHCP pool used for the Wi-Fi network. MikroTik access points (one connected to each switch) provide wireless access.



Guests can connect using a password and do not have access to internal network services. User authentication via Active Directory for Wi-Fi access is planned but not yet fully implemented.



# Additional Services

A second server is running TrueNAS and is intended to serve as a shared storage solution. The system is operational but not yet in production use, as no disks have been configured for active storage.

