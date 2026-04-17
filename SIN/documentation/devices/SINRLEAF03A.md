# SINRLEAF03A

## Table of Contents

- [Management](#management)
  - [Management Interfaces](#management-interfaces)
  - [Clock Settings](#clock-settings)
  - [NTP](#ntp)
  - [Management API HTTP](#management-api-http)
- [Authentication](#authentication)
  - [Enable Password](#enable-password)
  - [TACACS Servers](#tacacs-servers)
  - [IP TACACS Source Interfaces](#ip-tacacs-source-interfaces)
  - [AAA Server Groups](#aaa-server-groups)
- [Monitoring](#monitoring)
  - [TerminAttr Daemon](#terminattr-daemon)
  - [SNMP](#snmp)
- [Spanning Tree](#spanning-tree)
  - [Spanning Tree Summary](#spanning-tree-summary)
  - [Spanning Tree Device Configuration](#spanning-tree-device-configuration)
- [Internal VLAN Allocation Policy](#internal-vlan-allocation-policy)
  - [Internal VLAN Allocation Policy Summary](#internal-vlan-allocation-policy-summary)
  - [Internal VLAN Allocation Policy Device Configuration](#internal-vlan-allocation-policy-device-configuration)
- [VLANs](#vlans)
  - [VLANs Summary](#vlans-summary)
  - [VLANs Device Configuration](#vlans-device-configuration)
- [Interfaces](#interfaces)
  - [Interface Profiles](#interface-profiles)
  - [Ethernet Interfaces](#ethernet-interfaces)
  - [Loopback Interfaces](#loopback-interfaces)
  - [VLAN Interfaces](#vlan-interfaces)
  - [VXLAN Interface](#vxlan-interface)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [Virtual Router MAC Address](#virtual-router-mac-address)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
  - [Router BGP](#router-bgp)
- [BFD](#bfd)
  - [Router BFD](#router-bfd)
- [Multicast](#multicast)
  - [IP IGMP Snooping](#ip-igmp-snooping)
- [Filters](#filters)
  - [Prefix-lists](#prefix-lists)
  - [Route-maps](#route-maps)
- [Power Over Ethernet (PoE)](#power-over-ethernet-poe)
  - [PoE Summary](#poe-summary)
- [VRF Instances](#vrf-instances)
  - [VRF Instances Summary](#vrf-instances-summary)
  - [VRF Instances Device Configuration](#vrf-instances-device-configuration)
- [Virtual Source NAT](#virtual-source-nat)
  - [Virtual Source NAT Summary](#virtual-source-nat-summary)
  - [Virtual Source NAT Configuration](#virtual-source-nat-configuration)

## Management

### Management Interfaces

#### Management Interfaces Summary

##### IPv4

| Management Interface | Description | Type | VRF | IP Address | Gateway |
| -------------------- | ----------- | ---- | --- | ---------- | ------- |
| Management1 | OOB_MANAGEMENT | oob | MGMT | 10.120.34.91/24 | - |

##### IPv6

| Management Interface | Description | Type | VRF | IPv6 Address | IPv6 Gateway | ND RA RX Accept | ND RA Disabled | ND Managed Config Flag |
| -------------------- | ----------- | ---- | --- | ------------ | ------------ | --------------- | -------------- | ---------------------- |
| Management1 | OOB_MANAGEMENT | oob | MGMT | - | - | - | - | - |

#### Management Interfaces Device Configuration

```eos
!
interface Management1
   description OOB_MANAGEMENT
   no shutdown
   vrf MGMT
   ip address 10.120.34.91/24
```

### Clock Settings

#### Clock Timezone Settings

Clock Timezone is set to **Asia/Singapore**.

#### Clock Device Configuration

```eos
!
clock timezone Asia/Singapore
```

### NTP

#### NTP Summary

##### NTP Local Interface

| Interface | VRF |
| --------- | --- |
| Management1 | MGMT |

##### NTP Servers

NTP servers VRF: MGMT

| Server | Preferred | Burst | iBurst | Version | Min Poll | Max Poll | Local-interface | Key |
| ------ | --------- | ----- | ------ | ------- | -------- | -------- | --------------- | --- |
| 10.30.1.10 | True | - | - | - | - | - | - | - |
| 10.30.1.11 | - | - | - | - | - | - | - | - |

#### NTP Device Configuration

```eos
!
ntp local-interface vrf MGMT Management1
ntp server vrf MGMT 10.30.1.10 prefer
ntp server vrf MGMT 10.30.1.11
```

### Management API HTTP

#### Management API HTTP Summary

| HTTP | HTTPS | UNIX-Socket | Default Services | Session Timeout |
| ---- | ----- | ----------- | ---------------- | --------------- |
| False | True | - | - | 1440 minutes |

#### Management API VRF Access

| VRF Name | IPv4 ACL | IPv6 ACL |
| -------- | -------- | -------- |
| MGMT | - | - |

#### Management API HTTP Device Configuration

```eos
!
management api http-commands
   protocol https
   no shutdown
   !
   vrf MGMT
      no shutdown
```

## Authentication

### Enable Password

Enable password has been disabled

### TACACS Servers

#### TACACS Servers

| VRF | TACACS Servers | Single-Connection | Timeout |
| --- | -------------- | ----------------- | ------- |
| MGMT | 10.30.1.50 | False | - |
| MGMT | 10.30.1.51 | False | - |

#### TACACS Servers Device Configuration

```eos
!
tacacs-server host 10.30.1.50 vrf MGMT key 7 <removed>
tacacs-server host 10.30.1.51 vrf MGMT key 7 <removed>
```

### IP TACACS Source Interfaces

#### IP TACACS Source Interfaces

| VRF | Source Interface Name |
| --- | --------------------- |
| MGMT | Management1 |

#### IP TACACS Source Interfaces Device Configuration

```eos
!
ip tacacs vrf MGMT source-interface Management1
```

### AAA Server Groups

#### AAA Server Groups Summary

| Server Group Name | Type | VRF | IP address |
| ----------------- | ---- | --- | ---------- |
| TACACS_GROUP | tacacs+ | MGMT | 10.30.1.50 |
| TACACS_GROUP | tacacs+ | MGMT | 10.30.1.51 |

#### AAA Server Groups Device Configuration

```eos
!
aaa group server tacacs+ TACACS_GROUP
   server 10.30.1.50 vrf MGMT
   server 10.30.1.51 vrf MGMT
```

## Monitoring

### TerminAttr Daemon

#### TerminAttr Daemon Summary

| CV Compression | CloudVision Servers | VRF | Authentication | Smash Excludes | Ingest Exclude | Bypass AAA |
| -------------- | ------------------- | --- | -------------- | -------------- | -------------- | ---------- |
| gzip | 10.3.1.1:9910 | MGMT | token,/tmp/token | ale,flexCounter,hardware,kni,pulse,strata | - | False |

#### TerminAttr Daemon Device Configuration

```eos
!
daemon TerminAttr
   exec /usr/bin/TerminAttr -cvaddr=10.3.1.1:9910 -cvauth=token,/tmp/token -cvvrf=MGMT -smashexcludes=ale,flexCounter,hardware,kni,pulse,strata -taillogs -cvsourceintf=Management1
   no shutdown
```

### SNMP

#### SNMP Configuration Summary

| Contact | Location | SNMP Traps | State |
| ------- | -------- | ---------- | ----- |
| Global Network Operations Center <gnoc@example.com> | Global Campus Fabric | All | Disabled |

#### SNMP Communities

| Community | Access | Access List IPv4 | Access List IPv6 | View |
| --------- | ------ | ---------------- | ---------------- | ---- |
| <removed> | ro | - | - | - |
| <removed> | rw | - | - | - |

#### SNMP Device Configuration

```eos
!
snmp-server contact Global Network Operations Center <gnoc@example.com>
snmp-server location Global Campus Fabric
snmp-server community <removed> ro
snmp-server community <removed> rw
```

## Spanning Tree

### Spanning Tree Summary

STP mode: **mstp**

#### MSTP Instance and Priority

| Instance(s) | Priority |
| -------- | -------- |
| 0 | 32768 |

### Spanning Tree Device Configuration

```eos
!
spanning-tree mode mstp
spanning-tree mst 0 priority 32768
```

## Internal VLAN Allocation Policy

### Internal VLAN Allocation Policy Summary

| Policy Allocation | Range Beginning | Range Ending |
| ----------------- | --------------- | ------------ |
| ascending | 1006 | 1199 |

### Internal VLAN Allocation Policy Device Configuration

```eos
!
vlan internal order ascending range 1006 1199
```

## VLANs

### VLANs Summary

| VLAN ID | Name | Trunk Groups |
| ------- | ---- | ------------ |
| 10 | SIN_Test_VLAN | - |
| 20 | SIN_Access_Points | - |

### VLANs Device Configuration

```eos
!
vlan 10
   name SIN_Test_VLAN
!
vlan 20
   name SIN_Access_Points
```

## Interfaces

### Interface Profiles

#### Interface Profiles Summary

- IP-PUSHED_CONFIG

#### Interface Profiles Device Configuration

```eos
!
interface profile IP-PUSHED_CONFIG
   command switchport
   command switchport trunk native vlan 100
   command switchport trunk allowed vlan 200
   command switchport mode trunk
   command spanning-tree portfast
   command dot1x host-mode multi-host
```

### Ethernet Interfaces

#### Ethernet Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | Channel-Group |
| --------- | ----------- | ---- | ----- | ----------- | ----------- | ------------- |
| Ethernet1 | - | access | 10 | - | - | - |
| Ethernet2 | - | access | 10 | - | - | - |
| Ethernet3 | - | access | 10 | - | - | - |
| Ethernet4 | - | access | 10 | - | - | - |
| Ethernet5 | - | access | 10 | - | - | - |
| Ethernet6 | - | access | 10 | - | - | - |
| Ethernet7 | - | access | 10 | - | - | - |
| Ethernet8 | - | access | 10 | - | - | - |
| Ethernet9 | - | access | 10 | - | - | - |
| Ethernet10 | - | access | 10 | - | - | - |
| Ethernet11 | - | access | 10 | - | - | - |
| Ethernet12 | - | access | 10 | - | - | - |
| Ethernet13 | - | access | 10 | - | - | - |
| Ethernet14 | - | access | 10 | - | - | - |
| Ethernet15 | - | access | 10 | - | - | - |
| Ethernet16 | - | access | 10 | - | - | - |
| Ethernet17 | - | access | 10 | - | - | - |
| Ethernet18 | - | access | 10 | - | - | - |
| Ethernet19 | - | access | 10 | - | - | - |
| Ethernet20 | - | access | 10 | - | - | - |
| Ethernet21 | - | access | 10 | - | - | - |
| Ethernet22 | - | access | 10 | - | - | - |
| Ethernet23 | - | access | 10 | - | - | - |
| Ethernet24 | - | access | 10 | - | - | - |
| Ethernet25 | - | access | 20 | - | - | - |
| Ethernet26 | - | access | 20 | - | - | - |
| Ethernet27 | - | access | 20 | - | - | - |
| Ethernet28 | - | access | 20 | - | - | - |
| Ethernet29 | - | access | 20 | - | - | - |
| Ethernet30 | - | access | 20 | - | - | - |
| Ethernet31 | - | access | 20 | - | - | - |
| Ethernet32 | - | access | 20 | - | - | - |
| Ethernet33 | - | access | 20 | - | - | - |
| Ethernet34 | - | access | 20 | - | - | - |
| Ethernet35 | - | access | 20 | - | - | - |
| Ethernet36 | - | access | 20 | - | - | - |
| Ethernet37 | - | access | 20 | - | - | - |
| Ethernet38 | - | access | 20 | - | - | - |
| Ethernet39 | - | access | 20 | - | - | - |
| Ethernet40 | - | access | 20 | - | - | - |
| Ethernet41 | - | access | 20 | - | - | - |
| Ethernet42 | - | access | 20 | - | - | - |
| Ethernet43 | - | access | 20 | - | - | - |
| Ethernet44 | - | access | 20 | - | - | - |
| Ethernet45 | - | access | 20 | - | - | - |
| Ethernet46 | - | access | 20 | - | - | - |
| Ethernet47 | - | access | 20 | - | - | - |
| Ethernet48 | - | access | 20 | - | - | - |

*Inherited from Port-Channel Interface

##### IPv4

| Interface | Description | Channel Group | IP Address | VRF | MTU | Shutdown | ACL In | ACL Out |
| --------- | ----------- | ------------- | ---------- | --- | --- | -------- | ------ | ------- |
| Ethernet53 | P2P_SINRSPINE01A_Ethernet3 | - | 10.255.2.9/31 | default | 9214 | False | - | - |
| Ethernet54 | P2P_SINRSPINE02A_Ethernet3 | - | 10.255.2.11/31 | default | 9214 | False | - | - |

#### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet1
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet2
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet3
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet4
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet5
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet6
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet7
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet8
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet9
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet10
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet11
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet12
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet13
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet14
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet15
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet16
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet17
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet18
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet19
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet20
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet21
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet22
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet23
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet24
   no shutdown
   switchport access vlan 10
   switchport mode access
   switchport
   spanning-tree portfast
!
interface Ethernet25
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet26
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet27
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet28
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet29
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet30
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet31
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet32
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet33
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet34
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet35
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet36
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet37
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet38
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet39
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet40
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet41
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet42
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet43
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet44
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet45
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet46
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet47
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet48
   no shutdown
   switchport access vlan 20
   switchport mode access
   switchport
   poe priority high
   spanning-tree portfast
!
interface Ethernet53
   description P2P_SINRSPINE01A_Ethernet3
   no shutdown
   mtu 9214
   no switchport
   ip address 10.255.2.9/31
!
interface Ethernet54
   description P2P_SINRSPINE02A_Ethernet3
   no shutdown
   mtu 9214
   no switchport
   ip address 10.255.2.11/31
```

### Loopback Interfaces

#### Loopback Interfaces Summary

##### IPv4

| Interface | Description | VRF | IP Address |
| --------- | ----------- | --- | ---------- |
| Loopback0 | ROUTER_ID | default | 10.255.0.3/32 |
| Loopback1 | VXLAN_TUNNEL_SOURCE | default | 10.255.1.3/32 |
| Loopback2 | DIAG_VRF_TEST_VRF | TEST_VRF | 10.255.1.3/32 |

##### IPv6

| Interface | Description | VRF | IPv6 Addresses |
| --------- | ----------- | --- | -------------- |
| Loopback0 | ROUTER_ID | default | - |
| Loopback1 | VXLAN_TUNNEL_SOURCE | default | - |
| Loopback2 | DIAG_VRF_TEST_VRF | TEST_VRF | - |

#### Loopback Interfaces Device Configuration

```eos
!
interface Loopback0
   description ROUTER_ID
   no shutdown
   ip address 10.255.0.3/32
!
interface Loopback1
   description VXLAN_TUNNEL_SOURCE
   no shutdown
   ip address 10.255.1.3/32
!
interface Loopback2
   description DIAG_VRF_TEST_VRF
   no shutdown
   vrf TEST_VRF
   ip address 10.255.1.3/32
```

### VLAN Interfaces

#### VLAN Interfaces Summary

| Interface | Description | VRF | MTU | Shutdown |
| --------- | ----------- | --- | --- | -------- |
| Vlan10 | SIN_Test_VLAN | TEST_VRF | - | False |
| Vlan20 | SIN_Access_Points | TEST_VRF | - | False |

##### IPv4

| Interface | VRF | IP Address | IP Address Virtual | IP Router Virtual Address | ACL In | ACL Out |
| --------- | --- | ---------- | ------------------ | ------------------------- | ------ | ------- |
| Vlan10 | TEST_VRF | - | 10.0.0.1/24 | - | - | - |
| Vlan20 | TEST_VRF | - | 10.0.1.1/24 | - | - | - |

#### VLAN Interfaces Device Configuration

```eos
!
interface Vlan10
   description SIN_Test_VLAN
   no shutdown
   vrf TEST_VRF
   ip address virtual 10.0.0.1/24
!
interface Vlan20
   description SIN_Access_Points
   no shutdown
   vrf TEST_VRF
   ip address virtual 10.0.1.1/24
```

### VXLAN Interface

#### VXLAN Interface Summary

| Setting | Value |
| ------- | ----- |
| Source Interface | Loopback1 |
| UDP port | 4789 |

##### VLAN to VNI, Flood List and Multicast Group Mappings

| VLAN | VNI | Flood List | Multicast Group |
| ---- | --- | ---------- | --------------- |
| 10 | 20010 | - | - |
| 20 | 20020 | - | - |

##### VRF to VNI and Multicast Group Mappings

| VRF | VNI | Overlay Multicast Group to Encap Mappings |
| --- | --- | ----------------------------------------- |
| TEST_VRF | 1 | - |

#### VXLAN Interface Device Configuration

```eos
!
interface Vxlan1
   description SINRLEAF03A_VTEP
   vxlan source-interface Loopback1
   vxlan udp-port 4789
   vxlan vlan 10 vni 20010
   vxlan vlan 20 vni 20020
   vxlan vrf TEST_VRF vni 1
```

## Routing

### Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
```

### Virtual Router MAC Address

#### Virtual Router MAC Address Summary

Virtual Router MAC Address: 00:1c:73:00:00:99

#### Virtual Router MAC Address Device Configuration

```eos
!
ip virtual-router mac-address 00:1c:73:00:00:99
```

### IP Routing

#### IP Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | True |
| MGMT | False |
| TEST_VRF | True |

#### IP Routing Device Configuration

```eos
!
ip routing
no ip routing vrf MGMT
ip routing vrf TEST_VRF
```

### IPv6 Routing

#### IPv6 Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |
| MGMT | false |
| TEST_VRF | false |

### Router BGP

ASN Notation: asplain

#### Router BGP Summary

| BGP AS | Router ID |
| ------ | --------- |
| 65203 | 10.255.0.3 |

| BGP Tuning |
| ---------- |
| update wait-install |
| no bgp default ipv4-unicast |
| maximum-paths 4 |

#### Router BGP Peer Groups

##### EVPN-OVERLAY-PEERS

| Settings | Value |
| -------- | ----- |
| Address Family | evpn |
| Source | Loopback0 |
| BFD | True |
| Ebgp multihop | 3 |
| Send community | all |
| Maximum routes | 0 (no limit) |

##### IPv4-UNDERLAY-PEERS

| Settings | Value |
| -------- | ----- |
| Address Family | ipv4 |
| Send community | all |
| Maximum routes | 256000 |

#### BGP Neighbors

| Neighbor | Remote AS | VRF | Shutdown | Send-community | Maximum-routes | Allowas-in | BFD | RIB Pre-Policy Retain | Route-Reflector Client | Passive | TTL Max Hops |
| -------- | --------- | --- | -------- | -------------- | -------------- | ---------- | --- | --------------------- | ---------------------- | ------- | ------------ |
| 10.255.0.5 | 65200 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.255.0.6 | 65200 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.255.2.8 | 65200 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - | - | - |
| 10.255.2.10 | 65200 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - | - | - |

#### Router BGP EVPN Address Family

##### EVPN Peer Groups

| Peer Group | Activate | Route-map In | Route-map Out | Peer-tag In | Peer-tag Out | Encapsulation | Next-hop-self Source Interface |
| ---------- | -------- | ------------ | ------------- | ----------- | ------------ | ------------- | ------------------------------ |
| EVPN-OVERLAY-PEERS | True | - | - | - | - | default | - |

#### Router BGP VLANs

| VLAN | Route-Distinguisher | Both Route-Target | Import Route Target | Export Route-Target | Redistribute |
| ---- | ------------------- | ----------------- | ------------------- | ------------------- | ------------ |
| 10 | 10.255.0.3:20010 | 20010:20010 | - | - | learned |
| 20 | 10.255.0.3:20020 | 20020:20020 | - | - | learned |

#### Router BGP VRFs

| VRF | Route-Distinguisher | Redistribute | Graceful Restart |
| --- | ------------------- | ------------ | ---------------- |
| TEST_VRF | 10.255.0.3:1 | connected | - |

#### Router BGP Device Configuration

```eos
!
router bgp 65203
   router-id 10.255.0.3
   update wait-install
   no bgp default ipv4-unicast
   maximum-paths 4
   neighbor EVPN-OVERLAY-PEERS peer group
   neighbor EVPN-OVERLAY-PEERS update-source Loopback0
   neighbor EVPN-OVERLAY-PEERS bfd
   neighbor EVPN-OVERLAY-PEERS ebgp-multihop 3
   neighbor EVPN-OVERLAY-PEERS send-community
   neighbor EVPN-OVERLAY-PEERS maximum-routes 0
   neighbor IPv4-UNDERLAY-PEERS peer group
   neighbor IPv4-UNDERLAY-PEERS send-community
   neighbor IPv4-UNDERLAY-PEERS maximum-routes 256000
   neighbor 10.255.0.5 peer group EVPN-OVERLAY-PEERS
   neighbor 10.255.0.5 remote-as 65200
   neighbor 10.255.0.5 description SINRSPINE01A_Loopback0
   neighbor 10.255.0.6 peer group EVPN-OVERLAY-PEERS
   neighbor 10.255.0.6 remote-as 65200
   neighbor 10.255.0.6 description SINRSPINE02A_Loopback0
   neighbor 10.255.2.8 peer group IPv4-UNDERLAY-PEERS
   neighbor 10.255.2.8 remote-as 65200
   neighbor 10.255.2.8 description SINRSPINE01A_Ethernet3
   neighbor 10.255.2.10 peer group IPv4-UNDERLAY-PEERS
   neighbor 10.255.2.10 remote-as 65200
   neighbor 10.255.2.10 description SINRSPINE02A_Ethernet3
   redistribute connected route-map RM-CONN-2-BGP
   !
   vlan 10
      rd 10.255.0.3:20010
      route-target both 20010:20010
      redistribute learned
   !
   vlan 20
      rd 10.255.0.3:20020
      route-target both 20020:20020
      redistribute learned
   !
   address-family evpn
      neighbor EVPN-OVERLAY-PEERS activate
   !
   address-family ipv4
      no neighbor EVPN-OVERLAY-PEERS activate
      neighbor IPv4-UNDERLAY-PEERS activate
   !
   vrf TEST_VRF
      rd 10.255.0.3:1
      route-target import evpn 1:1
      route-target export evpn 1:1
      router-id 10.255.0.3
      redistribute connected
```

## BFD

### Router BFD

#### Router BFD Multihop Summary

| Interval | Minimum RX | Multiplier |
| -------- | ---------- | ---------- |
| 300 | 300 | 3 |

#### Router BFD Device Configuration

```eos
!
router bfd
   multihop interval 300 min-rx 300 multiplier 3
```

## Multicast

### IP IGMP Snooping

#### IP IGMP Snooping Summary

| IGMP Snooping | Fast Leave | Interface Restart Query | Proxy | Restart Query Interval | Robustness Variable |
| ------------- | ---------- | ----------------------- | ----- | ---------------------- | ------------------- |
| Enabled | - | - | - | - | - |

#### IP IGMP Snooping Device Configuration

```eos
```

## Filters

### Prefix-lists

#### Prefix-lists Summary

##### PL-LOOPBACKS-EVPN-OVERLAY

| Sequence | Action |
| -------- | ------ |
| 10 | permit 10.255.0.0/24 eq 32 |
| 20 | permit 10.255.1.0/24 eq 32 |

#### Prefix-lists Device Configuration

```eos
!
ip prefix-list PL-LOOPBACKS-EVPN-OVERLAY
   seq 10 permit 10.255.0.0/24 eq 32
   seq 20 permit 10.255.1.0/24 eq 32
```

### Route-maps

#### Route-maps Summary

##### RM-CONN-2-BGP

| Sequence | Type | Match | Set | Sub-Route-Map | Continue |
| -------- | ---- | ----- | --- | ------------- | -------- |
| 10 | permit | ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY | - | - | - |

#### Route-maps Device Configuration

```eos
!
route-map RM-CONN-2-BGP permit 10
   match ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY
```

## Power Over Ethernet (PoE)

### PoE Summary

#### PoE Interfaces

| Interface | PoE Enabled | Priority | Limit | Reboot Action | Link Down Action | Shutdown Action | LLDP Negotiation | Legacy Detection |
| --------- | --------- | --------- | ----------- | ----------- | ----------- | ----------- | --------- | --------- |
| Ethernet25 | True | high | - | - | - | - | - | - |
| Ethernet26 | True | high | - | - | - | - | - | - |
| Ethernet27 | True | high | - | - | - | - | - | - |
| Ethernet28 | True | high | - | - | - | - | - | - |
| Ethernet29 | True | high | - | - | - | - | - | - |
| Ethernet30 | True | high | - | - | - | - | - | - |
| Ethernet31 | True | high | - | - | - | - | - | - |
| Ethernet32 | True | high | - | - | - | - | - | - |
| Ethernet33 | True | high | - | - | - | - | - | - |
| Ethernet34 | True | high | - | - | - | - | - | - |
| Ethernet35 | True | high | - | - | - | - | - | - |
| Ethernet36 | True | high | - | - | - | - | - | - |
| Ethernet37 | True | high | - | - | - | - | - | - |
| Ethernet38 | True | high | - | - | - | - | - | - |
| Ethernet39 | True | high | - | - | - | - | - | - |
| Ethernet40 | True | high | - | - | - | - | - | - |
| Ethernet41 | True | high | - | - | - | - | - | - |
| Ethernet42 | True | high | - | - | - | - | - | - |
| Ethernet43 | True | high | - | - | - | - | - | - |
| Ethernet44 | True | high | - | - | - | - | - | - |
| Ethernet45 | True | high | - | - | - | - | - | - |
| Ethernet46 | True | high | - | - | - | - | - | - |
| Ethernet47 | True | high | - | - | - | - | - | - |
| Ethernet48 | True | high | - | - | - | - | - | - |

## VRF Instances

### VRF Instances Summary

| VRF Name | IP Routing |
| -------- | ---------- |
| MGMT | disabled |
| TEST_VRF | enabled |

### VRF Instances Device Configuration

```eos
!
vrf instance MGMT
!
vrf instance TEST_VRF
```

## Virtual Source NAT

### Virtual Source NAT Summary

| Source NAT VRF | Source NAT IPv4 Address | Source NAT IPv6 Address |
| -------------- | ----------------------- | ----------------------- |
| TEST_VRF | 10.255.1.3 | - |

### Virtual Source NAT Configuration

```eos
!
ip address virtual source-nat vrf TEST_VRF address 10.255.1.3
```
