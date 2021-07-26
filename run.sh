#!/bin/bash

echo "LDAP PASSWORD HUNTER"
echo "Please be sure impacket and ldapsearch are installed and your /etc/krb5.conf file is clean"

DCIP=$(cat conf.txt | grep dc-ip | cut -d " " -f 2)
USERNAME=$(cat conf.txt | grep username | cut -d " " -f 2)
USERDOMAIN=$(cat conf.txt | grep domain | cut -d " " -f 2)

if [ -z "DCIP" ] || [ -z "USERNAME" ] || [ -z "USERDOMAIN" ] ; then
    echo "Something is wrong in your conf.txt file"
 fi

impacket_check=$(which getTGT.py)
 if [ -z "$impacket_check" ] ; then
    echo "Please be sure impacket is installed in your system"
    exit 0
 fi


for DOMAIN in $(cat domains.txt)
do  
   source kerberos-ldap-password-finder-impacket-0.2.sh $DCIP "$(echo $DOMAIN | cut -d ":" -f 2)" $USERNAME "$(echo $DOMAIN | cut -d ":" -f 1)" $USERDOMAIN
done
