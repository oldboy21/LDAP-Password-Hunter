#!/bin/bash

echo "LDAP PASSWORD HUNTER"
echo "Please be sure impacket and ldapsearch are installed and your /etc/krb5.conf file is clean"

DCIP=$(cat conf.txt | grep dc-ip | cut -d " " -f 2)
USERNAME=$(cat conf.txt | grep username | cut -d " " -f 2)
USERDOMAIN=$(cat conf.txt | grep domain | cut -d " " -f 2)
#PASSWORD=$(cat conf.txt | grep password | cut -d " " -f 2)
DB="$(pwd)/ldapph.db"
if [ -f "$DB" ]; then 
   echo "Database exist already, Starting analysis on $(date)"
else 
  sqlite3 ldapph.db < create-database.sql
fi

if [ -z "DCIP" ] || [ -z "USERNAME" ] ; then
    echo "Something is wrong in your conf.txt file"
 fi

impacket_check=$(which getTGT.py)
 if [ -z "$impacket_check" ] ; then
    echo "Please be sure impacket is installed in your system"
    exit 0
 fi

ldapsearch_check=$(which ldapsearch)
 if [ -z "$ldapsearch_check" ] ; then
    echo "Please be sure ldapsearch is installed in your system"
    exit 0
 fi

sqlite_check=$(which sqlite3)
 if [ -z "$sqlite_check" ] ; then 
    echo "Please be sure sqlite3 is installed in your system"
    exit 0
 fi 

for DOMAIN in $(cat domains.txt)
do  
   source kerberos-ldap-password-hunter.sh $DCIP "$(echo $DOMAIN | cut -d ":" -f 2)" $USERNAME "$(echo $DOMAIN | cut -d ":" -f 1)" $USERDOMAIN
done
