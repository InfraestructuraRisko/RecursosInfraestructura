#!/bin/sh
# FIREWALL  RISKO
#SO2A - 2020
 
clear
#echo  "\n\t\t\t\tFIREWALL RISKO 2020"
#echo  "\t\t\t\t  INFRAESTRUCTURA\n"

#SE LIMPIAN LAS CONFIGURACIONES ANTERIORES QUE PUEDAN EXISTIR
echo  "\t\tLIMPIANDO CONFIGURACIONES..."
iptables -F 
iptables -X
iptables -Z
iptables -t nat -F

#SE COLOCAN LAS CONFIGURACIONES INICIALES O GENERALES
echo  "\t\tCONFIGURACIONES BASICAS..."
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

#SE  DA ACCESO A LAS MAQUINAS 
#echo  "\t\tABRIENDO PUERTOS A CLIENTES..."
 #INTERNA
iptables -A INPUT -s 192.168.100.0/24 -p tcp --dport  1:10000 -j ACCEPT
iptables -A INPUT -s 192.168.100.0/24 -p udp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.100.0/24 -p tcp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.100.0/24 -p udp --dport 1:10000 -j ACCEPT
#iptables -A INPUT -s 192.168.1.0/24 -p tcp --dport 10000 -j DROP
#iptables -A INPUT -s 192.168.1.0/24 -p udp --dport 10000 -j  DROP
 #DMZ
iptables -A INPUT -s 192.168.50.0/24 -p tcp --dport 1:10000 -j ACCEPT
iptables -A INPUT -s 192.168.50.0/24 -p udp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.50.0/24 -p udp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.50.0/24 -p tcp --dport 1:10000 -j ACCEPT
#iptables -A INPUT -s 192.168.50.0/24 -p tcp --dport 3306 -j ACCEPT
#iptables -A INPUT -s 192.168.50.0/24 -p tcp --dport 1:1024 -j ACCEPT

iptables -A INPUT -s 192.168.1.0/24 -p udp --dport 1:10000 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -p tcp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.1.0/24 -p tcp --dport 1:10000 -j ACCEPT
iptables -A OUTPUT -s 192.168.1.0/24 -p udp --dport 1:10000 -j ACCEPT
#iptables -A INPUT -s 192.168.43.229 -p udp --dport 1:1024 -j ACCEPT
#iptables -A INPUT -s 192.168.43.229 -p tcp --dport 10000 -j ACCEPT
#iptables -A INPUT -s 192.168.43.229 -p tcp --dport 3306 -j  ACCEPT

#ENMASCARAMIENTO DE CLIENTES
echo   "\t\tENMASCARAMIENTO..."
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o enp0s9 -j MASQUERADE

#BLOQUEO CONECTIVIDAD DMZ, WIRELESS
#echo  "\t\tBLOQUEO DMZ"
#iptables -A INPUT -s 192.168.50.0/24 --proto icmp  -j  DROP #DMZ A SERVER INTERNA
#iptables -A FORWARD -s 192.168.50.0/24 --proto icmp -d 192.168.100.0/24 -j DROP #PING DMZ INTERNA
#iptables -A FORWARD -s 192.168.50.0/24 --proto icmp -d 192.168.1.0/24 -j DROP  #SOLO PING DMZ A CLIENTES INTERNOS
#iptables -A FORWARD -s 192.168.43.0/24 --proto icmp -d 192.168.1.0/24 -j DROP #SOLO PING WIRELESS A INTERNA
#iptables -A FORWARD -s 192.168.1.0/24 --proto icmp -d 192.168.50.0/24 -j DROP #SOLO PING WIRELESS A DMZ
#iptables -A INPUT  -s 192.168.1.0/24 --proto icmp -d 192.168.50.20 -j DROP #SOLO PING WIRELESS A SERVER DMZ
#iptables -A INPUT -s 192.168.1.0/24 --proto icmp -d 192.168.43.2 -j DROP
#iptables -A INPUT -s 192.168.50.0/24  -d 192.168.1.0/24 -j DROP #DMZ A SERVER INTERNA
#iptables -A INPUT -s 192.168.43.0/24 -d 192.168.1.77 -j DROP #WIRELESS A SERVER INTERNA
#iptables -A INPUT -s 192.168.43.0/24 -d 192.168.50.20 -j DROP #WIRELESS A SERVER DMZ

#PROXY
#echo  "\t\tACTIVANDO PROXY"
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3128
#iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j REDIRECT --to-port 3128
#iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 443 -j REDIRECT --to-port 3128
iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3128 -j ACCEPT

#REDIRECCIONAMIENTO DE PUERTOS DE CORREO Y FTP A LA  DMZ
#echo  "\t\tREDIRECCIONAMIENTOS\n\n"
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 21 -j DNAT --to-destination 192.168.50.200:21
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 21 -j DNAT --to-destination 192.168.50.200:21
iptables -t nat -A PREROUTING -s 102.168.1.0/24 -p tcp --dport 993 -j DNAT --to-destination 192.168.50.200:993
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 110 -j DNAT --to-destination 192.168.50.200:110
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 587 -j DNAT --to-destination 192.168.50.200:587
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 8025 -j DNAT --to-destination 192.168.50.200:8025
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 143 -j DNAT --to-destination 192.168.50.200:143
#iptables -t nat -A PREROUTING -s 192.168.43.0/24 -p tcp --dport 143 -j DNAT --to-destination 192.168.50.66:143
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 465 -j DNAT --to-destination 192.168.50.200:465
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.50.200:80
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 443 -j DNAT --to-destination 192.168.50.200:443
#iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp -d 192.168.1.18/webmail -j DNAT --to-destination  192.168.50.200

#REDIRECCION DE SQL DE INTERFAZ EXTERNA
iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 3306  -j DNAT --to-destination 192.168.100.5:3306 #REDIRECCIONAMIENTO MYSQL

