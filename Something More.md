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
