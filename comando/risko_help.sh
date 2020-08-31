#!/bin/sh
  #INFERFACES
export MOD_INTERFACES="sudo nano /etc/network/interfaces"
export SAVE_INTERFACES='/etc/init.d/networking restart'
  #SAMBA
export CONF_SAMBA='sudo nano /etc/samba/smb.conf'
export RESTART_SAMBA='service smbd restart'
export STATUS_SAMBA=service smbd status
  #DHCP
export CONF_DHCP='sudo nano /etc/dhcp/dhcpd.conf'
export RESTART_DHCP='service isc-dhcp-server restart'
export STATUS_DHCP="service isc-dhcp-server status"
  #DNS
export CONF_DNS='sudo nano /etc/bind/db.riskodns.com'
export RESTART_DNS='service bind9 restart'
export STATUS_DNS='service bind9 status'
 #PROXY
export CONF_PROXY='sudo nano /etc/squid/squid.conf'
export RESTART_PROXY='service squid restart'
export STATUS_PROXY='service squid status'
 #VPN
export CONF_VPN='sudo nano /etc/pptpd/pptpd.conf'
export RESTART_VPN='service pptpd restart'
export STATUS_VPN='service pptpd status'
echo "VARIABLES ACTUALIZADAS"


