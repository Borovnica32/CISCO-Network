The CISCO Network project could become somthing more, a home for a Network Spanning AI, like a localy ran Claude Code with persistent memory of conversations, ability to inspect and communicate with diferent network segments, its own dedicated AD account for testing, network analysys and reporting and network trafic inspection.

It could serve as a isolated network for testing, this kind of system would have no risk to other infrastructure apart for its own.

The WI-FI part of the project would be disconnected due to safty conserns and no connection to the outside would be permited under ans circumstances.

Before the launch of this setup backups will have to be made in order to secure valid configuration of devices in case of critical faliour
Backups will have to include:
    - Ciso device OS backups
    - Config files for Cisco devices
    - Windows Server backup
    - TrueNAS backup
    - MikroTik devices OS backups
    - Config files for MikroTik devices

In addition to backups monitoring tools like WIreshark wil have to be installed on Window Server to monitor the AI network trafic

In case of critical faliour the system is to be shutdown imedietly, inspected and restored from a valid backup
If the AI begins to abuse it's AD privilegies and starts to destroy critical infrastructure the system is to be shit down imedietly, inspected and later restored from a valid backup

## Backup policy
Valid backups have to be safly stored on a offsite system (GutHub) to secure their integrity and prevent degredation of the backups, they also have to be made each time a important change is made in the configuration of the device

# Due to safty conserns phisical access will have to be limited to secure critical infrastructure and to maintain the isolated environment, only authorized personel may interact with the environment

Before the actual implementation some aditional resources willhave to be secured:
    - Increese RAM capacity for Windiws Server to maintain higher RAM demand when the AI model is installed and running (MAX RAM: 32 GB of DDR3-1600 SDRAM)
    - Install a new network card on Windows Server (MIN 2x RJ-45 port card)
    - Secure aditional disks for Windows Server and TrueNAS device to maintain data integrity and to mintain and store log files an relevant data (Not as imortaint as the Windows Server upgrade)

# PROBLEM SOLVING

## OSPF Exposure (IN PROGRESS)
Implemet `passive-interfaces`
    R1:
        router ospf 1
            passive-interface default
            no passive-interface g0/1
            no passive-interface g0/2
    R2:
        router ospf 1
            passive-interface default
            no passive-interface g0/1
            no passive-interface g0/2

OSPF authentication
    R1: 
        interface g0/1
            ip ospf authentication message-digest
            ip ospf message-digest-key 1 md5 MySecureKey123
    R2: 
        interface g0/1
            ip ospf authentication message-digest
            ip ospf message-digest-key 1 md5 MySecureKey123

## VLAN Filtering
Enable VLAN filtering across all interfaces
Extra ACL rules for VLANS
Inter VLAN filtering to be implemented

## TrueNAS
Move NAS to a dedicated VLAN and isolate it by restricting access to admins and backup groups
Make vlan 200 192.168.202.0/24

## Redundancy (SOLVED)
Alredy solved with OSPF routing with cost modifiers (route 1 = cost 10; route 2 = cost 20) if one faile the other one tajes its place

## Out-of-Bound management networks
Implement a way to seperate importaint segments like `management` segments and `TrueNAS` server (OOB networks)

## Disable `ip source-route` (DONE)
disable by using `no ip source-route`

## Fix DHCP pool (DONE)
default-router `192.168.100.1` -> default-router `192.168.3.1`

## Implement password encryption (DONE)
use `service password-encryption`

## ACL exists but not used (REDY)
```
access-list 100 permit tcp 192.168.101.0 0.0.0.255 host 192.168.100.1 eq 22
access-list 100 permit tcp 192.168.102.0 0.0.0.255 host 192.168.100.1 eq 22
```

Apply them: 

```
line vty 0 4
 access-class 100 in
 transport input ssh
```

## Toughter SSH rules (REDY)

```
ip ssh authentication-retries 3
login block-for 60 attempts 3 within 60

line vty 0 4
exec-timeout 10 0  ! Sets timeout to 10 minutes
```


## Logging of events (REDY)
Send logs to your server:

```
logging host 192.168.101.101
logging trap warnings
```
