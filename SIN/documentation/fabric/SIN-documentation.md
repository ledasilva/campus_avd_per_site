# SIN

## Table of Contents

- [Fabric Switches and Management IP](#fabric-switches-and-management-ip)
  - [Fabric Switches with inband Management IP](#fabric-switches-with-inband-management-ip)
- [Fabric Topology](#fabric-topology)
- [Fabric IP Allocation](#fabric-ip-allocation)
  - [Fabric Point-To-Point Links](#fabric-point-to-point-links)
  - [Point-To-Point Links Node Allocation](#point-to-point-links-node-allocation)
  - [Loopback Interfaces (BGP EVPN Peering)](#loopback-interfaces-bgp-evpn-peering)
  - [Loopback0 Interfaces Node Allocation](#loopback0-interfaces-node-allocation)
  - [VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)](#vtep-loopback-vxlan-tunnel-source-interfaces-vteps-only)
  - [VTEP Loopback Node allocation](#vtep-loopback-node-allocation)

## Fabric Switches and Management IP

| POD | Type | Node | Management IP | Platform | Provisioned in CloudVision | Serial Number |
| --- | ---- | ---- | ------------- | -------- | -------------------------- | ------------- |
| SIN | l3leaf | SINRLEAF01A | 10.10.101.21/24 | DCS-720XP-48TXH | Provisioned | - |
| SIN | l3leaf | SINRLEAF02A | 10.10.101.22/24 | DCS-720XP-48TXH | Provisioned | - |
| SIN | l3leaf | SINRLEAF03A | 10.120.34.91/24 | CCS-758 | Provisioned | - |
| SIN | spine | SINRSPINE01A | 10.10.101.11/24 | DCS-7050PX4 | Provisioned | - |
| SIN | spine | SINRSPINE02A | 10.10.101.12/24 | DCS-7050PX4 | Provisioned | - |

> Provision status is based on Ansible inventory declaration and do not represent real status from CloudVision.

### Fabric Switches with inband Management IP

| POD | Type | Node | Management IP | Inband Interface |
| --- | ---- | ---- | ------------- | ---------------- |

## Fabric Topology

| Type | Node | Node Interface | Peer Type | Peer Node | Peer Interface |
| ---- | ---- | -------------- | --------- | --------- | -------------- |
| l3leaf | SINRLEAF01A | Ethernet49 | spine | SINRSPINE01A | Ethernet1 |
| l3leaf | SINRLEAF01A | Ethernet50 | spine | SINRSPINE02A | Ethernet1 |
| l3leaf | SINRLEAF01A | Ethernet51 | mlag_peer | SINRLEAF02A | Ethernet51 |
| l3leaf | SINRLEAF01A | Ethernet52 | mlag_peer | SINRLEAF02A | Ethernet52 |
| l3leaf | SINRLEAF02A | Ethernet49 | spine | SINRSPINE01A | Ethernet2 |
| l3leaf | SINRLEAF02A | Ethernet50 | spine | SINRSPINE02A | Ethernet2 |
| l3leaf | SINRLEAF03A | Ethernet53 | spine | SINRSPINE01A | Ethernet3 |
| l3leaf | SINRLEAF03A | Ethernet54 | spine | SINRSPINE02A | Ethernet3 |

## Fabric IP Allocation

### Fabric Point-To-Point Links

| Uplink IPv4 Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ---------------- | ------------------- | ------------------ | ------------------ |
| 10.255.2.0/24 | 256 | 12 | 4.69 % |

### Point-To-Point Links Node Allocation

| Node | Node Interface | Node IP Address | Peer Node | Peer Interface | Peer IP Address |
| ---- | -------------- | --------------- | --------- | -------------- | --------------- |
| SINRLEAF01A | Ethernet49 | 10.255.2.1/31 | SINRSPINE01A | Ethernet1 | 10.255.2.0/31 |
| SINRLEAF01A | Ethernet50 | 10.255.2.3/31 | SINRSPINE02A | Ethernet1 | 10.255.2.2/31 |
| SINRLEAF02A | Ethernet49 | 10.255.2.5/31 | SINRSPINE01A | Ethernet2 | 10.255.2.4/31 |
| SINRLEAF02A | Ethernet50 | 10.255.2.7/31 | SINRSPINE02A | Ethernet2 | 10.255.2.6/31 |
| SINRLEAF03A | Ethernet53 | 10.255.2.9/31 | SINRSPINE01A | Ethernet3 | 10.255.2.8/31 |
| SINRLEAF03A | Ethernet54 | 10.255.2.11/31 | SINRSPINE02A | Ethernet3 | 10.255.2.10/31 |

### Loopback Interfaces (BGP EVPN Peering)

| Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ------------- | ------------------- | ------------------ | ------------------ |
| 10.255.0.0/24 | 256 | 5 | 1.96 % |

### Loopback0 Interfaces Node Allocation

| POD | Node | Loopback0 |
| --- | ---- | --------- |
| SIN | SINRLEAF01A | 10.255.0.1/32 |
| SIN | SINRLEAF02A | 10.255.0.2/32 |
| SIN | SINRLEAF03A | 10.255.0.3/32 |
| SIN | SINRSPINE01A | 10.255.0.5/32 |
| SIN | SINRSPINE02A | 10.255.0.6/32 |

### VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)

| VTEP Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ------------------ | ------------------- | ------------------ | ------------------ |
| 10.255.1.0/24 | 256 | 3 | 1.18 % |

### VTEP Loopback Node allocation

| POD | Node | Loopback1 |
| --- | ---- | --------- |
| SIN | SINRLEAF01A | 10.255.1.1/32 |
| SIN | SINRLEAF02A | 10.255.1.1/32 |
| SIN | SINRLEAF03A | 10.255.1.3/32 |
