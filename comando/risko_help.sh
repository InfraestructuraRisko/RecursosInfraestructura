#!/bin/sh
  #INFERFACES
MOD_INTERFACES='sudo nano /etc/network/interfaces'
SAVE_INTERFACES='/etc/init.d/networking restart'
  #SAMBA
$CONF_SAMBA='sudo nano /etc/samba/smb.conf'
$RESTART_SAMBA='service smbd restart'
$STATUSUS_SAMBA='service smbd status'
  #DHCP
$CONF_DHCP='sudo nano /etc/dhcp/dhcpd.conf'
$RESTART_DHCP='service isc-dhcp-server restart'
$STATUS_DHCP='service isc-dhcp-server status'
  #DNS
$CONF_DNS='sudo nano /etc/bind/db.riskodns.com'
$RESTART_DNS='service bind9 restart'
$STATUS_DNS='service bind9 status'
 #PROXY
$CONF_PROXY='sudo nano /etc/squid/squid.conf'
$RESTART_PROXY='service squid restart'
$STATUS_PROXY='service squid status'
 #VPN
$CONF_VPN='sudo nano /etc/squid/squid.conf'
$RESTART_VPN='service squid restart'
$RESTART_VPN='service squid status'
echo "VARIABLES ACTUALIZADAS"


