# jan/02/1970 01:17:13 by RouterOS 6.49.10
# software id = ZE3B-F9LL
#
# model = RB962UiGS-5HacT2HnT
# serial number = HE208QB0V5Q
/interface bridge
add admin-mac=48:A9:8A:4B:34:AD auto-mac=no comment=defconf name=bridge
add name=cisco-bridge
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-g/n channel-width=20/40mhz-Ce \
    disabled=no distance=indoors frequency=auto installation=indoor mode=\
    ap-bridge ssid=Main-WIFI wireless-protocol=802.11
set [ find default-name=wlan2 ] band=5ghz-a/n/ac channel-width=\
    20/40/80mhz-XXXX disabled=no distance=indoors frequency=auto \
    installation=indoor mode=ap-bridge ssid=MikroTik-4B34B2 \
    wireless-protocol=802.11
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip dhcp-server
add disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=ether5
add bridge=bridge comment=defconf interface=sfp1
add bridge=bridge comment=defconf interface=wlan2
add bridge=cisco-bridge interface=ether3
add bridge=cisco-bridge interface=wlan1
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
add interface=cisco-bridge list=LAN
/ip address
add address=192.168.3.254/24 interface=cisco-bridge network=192.168.3.0
/ip dns
set allow-remote-requests=yes
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/ip route
add distance=1 gateway=192.168.3.1
/ip service
set winbox address=0.0.0.0/0
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
/user aaa
set default-group=full use-radius=yes
