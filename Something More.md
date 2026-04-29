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


# ZBF
## R1

### Zone decleration
    zone security R1.LAN
    zone security R1.MGMT
    zone security R1.CORE
    zone security R1.SELF

### Zone pair decleration
    zone-pair security R1.LAN-R1.CORE source R1.LAN destination R1.CORE
    zone-pair security R1.MGMT-R1.CORE source R1.MGMT destination R1.CORE

    zone-pair security R1.MGMT-R1.SELF source R1.MGMT destination R1.SELF
    zone-pair security R1.CORE-R1.SELF source R1.CORE destination R1.SELF

### Main ACL
    ip access-list extended LAN-TO-MGMT
        remark === TrueNAS (R2) ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 445    ! R1.LAN 
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 445    ! R2.LAN

        permit tcp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 80    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 80    ! R2.LAN

        permit tcp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 443    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 443    ! R2.LAN

        permit udp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 69    ! R1.LAN
        permit udp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 69    ! R2.LAN

        remark === Windows Server (AD + RADIUS) ===
        remark === Kerberos ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 88    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 88    ! R2.LAN

        remark === LDAP ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 389    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 389    ! R2.LAN

        remark === RADIUS ===
        permit udp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 1812    ! R1.LAN
        permit udp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 1813    ! R1.LAN

        permit udp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 1812    ! R2.LAN
        permit udp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 1813    ! R2.LAN

        remark === RPC ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 135
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 135

        remark === Dynamic RPC ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 range 49152 65535
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 range 49152 65535

### Class Maps
    class-map type inspect match-any CM-LAN-MGMT
        match access-group name LAN-TO-MGMT

    class-map type inspect match-any CM-SSH
        match protocol ssh
    
    class-map type inspect match-any CM-ROUTING
        match protocol ospf

### Policy Maps
    policy-map type inspect PM-LAN-CORE
        class CM-LAN-MGMT
            inspect
        class class-default
            drop

    policy-map type inspect PM-MGMT-CORE
        class CM-MGMT-LAN
            inspect
        class class-default
            drop

    policy-map type inspect PM-MGMT-SELF
        class CM-SSH
            pass
        class class-default
            drop

    policy-map type inspect PM-CORE-SELF
        class CM-ROUTING
            pass
        class CM-SSH
            pass
        class class-default
            drop

### Link Policy to zone-pair

    zone-pair security R1.LAN-R1.CORE
        service-policy type inspect PM-LAN-CORE

    zone-pair security R1.MGMT-R1.CORE
        service-policy type inspect PM-MGMT-CORE

    zone-pair security R1.MGMT-R1.SELF
        service-policy type inspect PM-MGMT-SELF

    zone-pair security R1.CORE-R1.SELF
        service-policy type inspect PM-CORE-SELF

    
## R2
### Zone decleration
    zone security R2.LAN
    zone security R2.MGMT
    zone security R2.CORE
    zone security R2.SELF

### Zone pair decleration
    zone-pair security R2.LAN-R2.CORE source R2.LAN destination R2.CORE
    zone-pair security R2.MGMT-R2.CORE source R2.MGMT destination R2.CORE

    zone-pair security R2.MGMT-R2.SELF source R2.MGMT destination R2.SELF
    zone-pair security R2.CORE-R2.SELF source R2.CORE destination R2.SELF

### Main ACL
    ip access-list extended LAN-TO-MGMT
        remark === TrueNAS (R2) ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 445    ! R1.LAN 
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 445    ! R2.LAN

        permit tcp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 80    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 80    ! R2.LAN

        permit tcp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 443    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 443    ! R2.LAN

        permit udp 192.168.1.0 0.0.0.255 host 192.168.102.102 eq 69    ! R1.LAN
        permit udp 192.168.2.0 0.0.0.255 host 192.168.102.102 eq 69    ! R2.LAN

        remark === Windows Server (AD + RADIUS) ===
        ! Kerberos
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 88    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 88    ! R2.LAN

        ! LDAP
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 389    ! R1.LAN
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 389    ! R2.LAN

        ! RADIUS
        permit udp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 1812    ! R1.LAN
        permit udp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 1813    ! R1.LAN

        permit udp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 1812    ! R2.LAN
        permit udp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 1813    ! R2.LAN

        remark === RPC ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 eq 135
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 eq 135

        remark === Dynamic RPC ===
        permit tcp 192.168.1.0 0.0.0.255 host 192.168.101.101 range 49152 65535
        permit tcp 192.168.2.0 0.0.0.255 host 192.168.101.101 range 49152 65535

### Class Maps
    class-map type inspect match-any CM-LAN-MGMT
        match access-group name LAN-TO-MGMT

    class-map type inspect match-any CM-SSH
        match protocol ssh
    
    class-map type inspect match-any CM-ROUTING
        match protocol ospf

### Policy Maps
    policy-map type inspect PM-LAN-CORE
        class CM-LAN-MGMT
            inspect
        class class-default
            drop

    policy-map type inspect PM-MGMT-CORE
        class CM-MGMT-LAN
            inspect
        class class-default
            drop

    policy-map type inspect PM-MGMT-SELF
        class CM-SSH
            pass
        class class-default
            drop

    policy-map type inspect PM-CORE-SELF
        class CM-ROUTING
            pass
        class CM-SSH
            pass
        class class-default
            drop

### Link Policy to zone-pair

    zone-pair security R2.LAN-R2.CORE
        service-policy type inspect PM-LAN-CORE

    zone-pair security R2.MGMT-R2.CORE
        service-policy type inspect PM-MGMT-CORE

    zone-pair security R2.MGMT-R2.SELF
        service-policy type inspect PM-MGMT-SELF

    zone-pair security R2.CORE-R2.SELF
        service-policy type inspect PM-CORE-SELF
