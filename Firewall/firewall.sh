#!/bin/sh
# FIREWALL  RISKO

clear
echo  "FIREWALL RISKO 2020"
echo  "INFRAESTRUCTURA"

#SE LIMPIAN LAS CONFIGURACIONES ANTERIORES QUE PUEDAN EXISTIR
echo  "\tLIMPIANDO CONFIGURACIONES"
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

#SE COLOCAN LAS CONFIGURACIONES INICIALES O GENERALES
echo  "\tCONFIGURACIONES BASICAS"
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

echo "\tADMITIENDO CONEXIOSNES INTERFACES"
 echo "\t\tINTERNA"
iptables -A INPUT -s 192.168.100.0/24 -p tcp --dport  1:10000 -j ACCEPT
iptables -A INPUT -s 192.168.100.0/24 -p udp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.100.0/24 -p tcp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.100.0/24 -p udp --dport 1:10000 -j ACCEPT
 echo "\t\tDMZ"
iptables -A INPUT -s 192.168.50.0/24 -p tcp --dport 1:10000 -j ACCEPT
iptables -A INPUT -s 192.168.50.0/24 -p udp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.50.0/24 -p udp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.50.0/24 -p tcp --dport 1:10000 -j ACCEPT
 echo "\t\tEXTERNA"
iptables -A INPUT -s 192.168.1.0/24 -p tcp --dport 10000 -j DROP
echo "\t\tVPN"
iptables -A INPUT -s 192.168.0.0/24 -p tcp --dport 10000 -j ACCEPT
#iptables -A OUTPUT -s 192.168.1.0/24 -p tcp --dport 1:10000 -j ACCEPT
#iptables -A OUTPUT -s 192.168.1.0/24 -p udp --dport 1:10000 -j ACCEPT

#ENMASCARAMIENTO DE CONEXION
echo   "\tENMASCARAMIENTO"
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o enp0s9 -j MASQUERADE

echo "\tRESTRICCIONES DE CONNECTIVIDAD"
 echo "\t\tFORDWARDING"
iptables -A FORWARD -s 192.168.50.0/24 --proto icmp -d 192.168.100.0/24 -j DROP #DMZ INTERNA
iptables -A FORWARD -s 192.168.50.0/24 --proto icmp -d 192.168.1.0/24 -j DROP  #DMZ EXTERNA
iptables -A FORWARD -s 192.168.100.0/24 --proto icmp -d 192.168.50.0/24 -j DROP #INTERNA DMZ
iptables -A FORWARD -s 192.168.100.0/24 --proto icmp -d 192.168.1.0/24 -j DROP #INTERNA EXTERNA
iptables -A FORWARD -s 192.168.1.0/24 --proto icmp -d 192.168.50.0/24 -j DROP #EXTERNA DMZ
iptables -A FORWARD -s 192.168.1.0/24 --proto icmp -d 192.168.100.0/24 -j DROP #EXTERNA INTERNA
 echo "\t\tINPUT"
iptables -A INPUT -s 192.168.50.0/24 --proto icmp  -d 192.168.1.0/24 -j DROP #DMZ A SERVER  EXTERNA
iptables -A INPUT -s 192.168.50.0/24 --proto icmp -d 192.168.100.0/24 -j DROP #DMZ A SERVEER INTERNA
iptables -A INPUT -s 192.168.1.0/24 --proto icmp -d 192.168.50.0/24 -j DROP #EXTERNA A SERVER DMZ
iptables -A INPUT -s 192.168.1.0/24 --proto icmp -d 192.168.100.0/24 -j DROP #EXTERNA A SERVER INTERNA
iptables -A INPUT -s 192.168.100.0/24 --proto icmp -d 192.168.1.0/24 -j DROP #INTERNA A SERVER EXTERNA
iptables -A INPUT -s 192.168.100.0/24 --proto icmp -d 192.168.50.0/24 -j DROP #INTERNA A SERVER DMZ

echo "\tPROXY"
echo  "\t\tREDIRECCION PROXY"
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 443 -j REDIRECT --to-port 3128
iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3128 -j ACCEPT

#REDIRECCIONAMIENTO DE PUERTOS DE CORREO Y FTP A LA  DMZ
echo  "\tREDIRECCIONAMIENTOS"
echo "\t\tFTP"
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 21 -j DNAT --to-destination 192.168.50.200:21
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 21 -j DNAT --to-destination 192.168.50.200:21
echo "\t\tCORREOS"
iptables -t nat -A PREROUTING -s 102.168.1.0/24 -p tcp --dport 993 -j DNAT --to-destination 192.168.50.200:993
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 110 -j DNAT --to-destination 192.168.50.200:110
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 587 -j DNAT --to-destination 192.168.50.200:587
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 8025 -j DNAT --to-destination 192.168.50.200:8025
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 143 -j DNAT --to-destination 192.168.50.200:143
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 465 -j DNAT --to-destination 192.168.50.200:465
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.50.200:80
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 443 -j DNAT --to-destination 192.168.50.200:443
#REDIRECCION DE SQL DE INTERFAZ EXTERNA
echo "\t\tMYSQL"
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 3306  -j DNAT --to-destination 192.168.100.5:3306 #REDIRECCIONAMIENTO MYSQL
