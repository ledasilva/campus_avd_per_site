# LABRSPINE01A

## Table of Contents

- [Management](#management)
  - [Management Interfaces](#management-interfaces)
  - [IP Name Servers](#ip-name-servers)
  - [Domain Lookup](#domain-lookup)
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
- [Interfaces](#interfaces)
  - [Ethernet Interfaces](#ethernet-interfaces)
  - [Loopback Interfaces](#loopback-interfaces)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
  - [Router BGP](#router-bgp)
- [BFD](#bfd)
  - [Router BFD](#router-bfd)
- [Filters](#filters)
  - [Prefix-lists](#prefix-lists)
  - [Route-maps](#route-maps)
- [VRF Instances](#vrf-instances)
  - [VRF Instances Summary](#vrf-instances-summary)
  - [VRF Instances Device Configuration](#vrf-instances-device-configuration)

## Management

### Management Interfaces

#### Management Interfaces Summary

##### IPv4

| Management Interface | Description | Type | VRF | IP Address | Gateway |
| -------------------- | ----------- | ---- | --- | ---------- | ------- |
| Management1 | OOB_MANAGEMENT | oob | MGMT | 10.10.101.11/24 | - |

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
   ip address 10.10.101.11/24
```

### IP Name Servers

#### IP Name Servers Summary

| Name Server | VRF | Priority |
| ----------- | --- | -------- |
| 1.1.1.1 | MGMT | - |
| 1.1.1.2 | MGMT | - |

#### IP Name Servers Device Configuration

```eos
ip name-server vrf MGMT 1.1.1.1
ip name-server vrf MGMT 1.1.1.2
```

### Domain Lookup

#### DNS Domain Lookup Summary

| Source interface | vrf |
| ---------------- | --- |
| Management1 | MGMT |

#### DNS Domain Lookup Device Configuration

```eos
ip domain lookup vrf MGMT source-interface Management1
```

### Clock Settings

#### Clock Timezone Settings

Clock Timezone is set to **UTC**.

#### Clock Device Configuration

```eos
!
clock timezone UTC
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
| ntp1.ntp.com | True | - | - | - | - | - | - | - |
| ntp2.ntp.com | - | - | - | - | - | - | - | - |

#### NTP Device Configuration

```eos
!
ntp local-interface vrf MGMT Management1
ntp server vrf MGMT ntp1.ntp.com prefer
ntp server vrf MGMT ntp2.ntp.com
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
| MGMT | 2.2.2.1 | False | - |
| MGMT | 2.2.2.2 | False | - |

#### TACACS Servers Device Configuration

```eos
!
tacacs-server host 2.2.2.1 vrf MGMT key 7 <removed>
tacacs-server host 2.2.2.2 vrf MGMT key 7 <removed>
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
| TACACS_GROUP | tacacs+ | MGMT | 2.2.2.1 |
| TACACS_GROUP | tacacs+ | MGMT | 2.2.2.2 |

#### AAA Server Groups Device Configuration

```eos
!
aaa group server tacacs+ TACACS_GROUP
   server 2.2.2.1 vrf MGMT
   server 2.2.2.2 vrf MGMT
```

## Monitoring

### TerminAttr Daemon

#### TerminAttr Daemon Summary

| CV Compression | CloudVision Servers | VRF | Authentication | Smash Excludes | Ingest Exclude | Bypass AAA |
| -------------- | ------------------- | --- | -------------- | -------------- | -------------- | ---------- |
| gzip | 10.1.1.1:9910 | MGMT | token,/tmp/token | ale,flexCounter,hardware,kni,pulse,strata | - | False |

#### TerminAttr Daemon Device Configuration

```eos
!
daemon TerminAttr
   exec /usr/bin/TerminAttr -cvaddr=10.1.1.1:9910 -cvauth=token,/tmp/token -cvvrf=MGMT -smashexcludes=ale,flexCounter,hardware,kni,pulse,strata -taillogs -cvsourceintf=Management1
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

STP mode: **none**

### Spanning Tree Device Configuration

```eos
!
spanning-tree mode none
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

## Interfaces

### Ethernet Interfaces

#### Ethernet Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | Channel-Group |
| --------- | ----------- | ---- | ----- | ----------- | ----------- | ------------- |

*Inherited from Port-Channel Interface

##### IPv4

| Interface | Description | Channel Group | IP Address | VRF | MTU | Shutdown | ACL In | ACL Out |
| --------- | ----------- | ------------- | ---------- | --- | --- | -------- | ------ | ------- |
| Ethernet1 | P2P_LABRLEAF01A_Ethernet49 | - | 10.255.2.0/31 | default | 9214 | False | - | - |
| Ethernet2 | P2P_LABRLEAF02A_Ethernet49 | - | 10.255.2.4/31 | default | 9214 | False | - | - |
| Ethernet3 | P2P_LABRLEAF03A_Ethernet53 | - | 10.255.2.8/31 | default | 9214 | False | - | - |

#### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet1
   description P2P_LABRLEAF01A_Ethernet49
   no shutdown
   mtu 9214
   no switchport
   ip address 10.255.2.0/31
!
interface Ethernet2
   description P2P_LABRLEAF02A_Ethernet49
   no shutdown
   mtu 9214
   no switchport
   ip address 10.255.2.4/31
!
interface Ethernet3
   description P2P_LABRLEAF03A_Ethernet53
   no shutdown
   mtu 9214
   no switchport
   ip address 10.255.2.8/31
```

### Loopback Interfaces

#### Loopback Interfaces Summary

##### IPv4

| Interface | Description | VRF | IP Address |
| --------- | ----------- | --- | ---------- |
| Loopback0 | ROUTER_ID | default | 10.255.0.5/32 |

##### IPv6

| Interface | Description | VRF | IPv6 Addresses |
| --------- | ----------- | --- | -------------- |
| Loopback0 | ROUTER_ID | default | - |

#### Loopback Interfaces Device Configuration

```eos
!
interface Loopback0
   description ROUTER_ID
   no shutdown
   ip address 10.255.0.5/32
```

## Routing

### Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
```

### IP Routing

#### IP Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | True |
| MGMT | False |

#### IP Routing Device Configuration

```eos
!
ip routing
no ip routing vrf MGMT
```

### IPv6 Routing

#### IPv6 Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |
| MGMT | false |

### Router BGP

ASN Notation: asplain

#### Router BGP Summary

| BGP AS | Router ID |
| ------ | --------- |
| 65100 | 10.255.0.5 |

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
| Next-hop unchanged | True |
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
| 10.255.0.1 | 65101 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.255.0.2 | 65101 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.255.0.3 | 65103 | default | - | Inherited from peer group EVPN-OVERLAY-PEERS | Inherited from peer group EVPN-OVERLAY-PEERS | - | Inherited from peer group EVPN-OVERLAY-PEERS | - | - | - | - |
| 10.255.2.1 | 65101 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - | - | - |
| 10.255.2.5 | 65101 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - | - | - |
| 10.255.2.9 | 65103 | default | - | Inherited from peer group IPv4-UNDERLAY-PEERS | Inherited from peer group IPv4-UNDERLAY-PEERS | - | - | - | - | - | - |

#### Router BGP EVPN Address Family

##### EVPN Peer Groups

| Peer Group | Activate | Route-map In | Route-map Out | Peer-tag In | Peer-tag Out | Encapsulation | Next-hop-self Source Interface |
| ---------- | -------- | ------------ | ------------- | ----------- | ------------ | ------------- | ------------------------------ |
| EVPN-OVERLAY-PEERS | True | - | - | - | - | default | - |

#### Router BGP Device Configuration

```eos
!
router bgp 65100
   router-id 10.255.0.5
   update wait-install
   no bgp default ipv4-unicast
   maximum-paths 4
   neighbor EVPN-OVERLAY-PEERS peer group
   neighbor EVPN-OVERLAY-PEERS next-hop-unchanged
   neighbor EVPN-OVERLAY-PEERS update-source Loopback0
   neighbor EVPN-OVERLAY-PEERS bfd
   neighbor EVPN-OVERLAY-PEERS ebgp-multihop 3
   neighbor EVPN-OVERLAY-PEERS send-community
   neighbor EVPN-OVERLAY-PEERS maximum-routes 0
   neighbor IPv4-UNDERLAY-PEERS peer group
   neighbor IPv4-UNDERLAY-PEERS send-community
   neighbor IPv4-UNDERLAY-PEERS maximum-routes 256000
   neighbor 10.255.0.1 peer group EVPN-OVERLAY-PEERS
   neighbor 10.255.0.1 remote-as 65101
   neighbor 10.255.0.1 description LABRLEAF01A_Loopback0
   neighbor 10.255.0.2 peer group EVPN-OVERLAY-PEERS
   neighbor 10.255.0.2 remote-as 65101
   neighbor 10.255.0.2 description LABRLEAF02A_Loopback0
   neighbor 10.255.0.3 peer group EVPN-OVERLAY-PEERS
   neighbor 10.255.0.3 remote-as 65103
   neighbor 10.255.0.3 description LABRLEAF03A_Loopback0
   neighbor 10.255.2.1 peer group IPv4-UNDERLAY-PEERS
   neighbor 10.255.2.1 remote-as 65101
   neighbor 10.255.2.1 description LABRLEAF01A_Ethernet49
   neighbor 10.255.2.5 peer group IPv4-UNDERLAY-PEERS
   neighbor 10.255.2.5 remote-as 65101
   neighbor 10.255.2.5 description LABRLEAF02A_Ethernet49
   neighbor 10.255.2.9 peer group IPv4-UNDERLAY-PEERS
   neighbor 10.255.2.9 remote-as 65103
   neighbor 10.255.2.9 description LABRLEAF03A_Ethernet53
   redistribute connected route-map RM-CONN-2-BGP
   !
   address-family evpn
      neighbor EVPN-OVERLAY-PEERS activate
   !
   address-family ipv4
      no neighbor EVPN-OVERLAY-PEERS activate
      neighbor IPv4-UNDERLAY-PEERS activate
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

## Filters

### Prefix-lists

#### Prefix-lists Summary

##### PL-LOOPBACKS-EVPN-OVERLAY

| Sequence | Action |
| -------- | ------ |
| 10 | permit 10.255.0.0/24 eq 32 |

#### Prefix-lists Device Configuration

```eos
!
ip prefix-list PL-LOOPBACKS-EVPN-OVERLAY
   seq 10 permit 10.255.0.0/24 eq 32
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

## VRF Instances

### VRF Instances Summary

| VRF Name | IP Routing |
| -------- | ---------- |
| MGMT | disabled |

### VRF Instances Device Configuration

```eos
!
vrf instance MGMT
```
