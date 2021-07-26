#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
ORANGE='\033[0;33m'
echo -e "${GREEN}****LDAP PASSWORD ENUM****${NC}"
#1 dc-ip
#2 DC hostname ( for the SPN )
#3 username
#4 domain 
echo $5
if [ -z $KRB5CCNAME ] ; then  
	echo "Creating a TGT ticket for the user"
	getTGT.py -dc-ip $1 $5/$3
	mv $3.ccache $3TGT.ccache
	export KRB5CCNAME="$(pwd)"/$3TGT.ccache
	echo $KRB5CCNAME
fi 
DOMAIN=$4
base=""
filter="(|"
baseconf="CN=Schema,CN=Configuration,"
baseconf+=$(ldapsearch -R $5 -h $2.$DOMAIN -Y GSSAPI -s base -b "" rootDomainNamingContext | grep -i rootDomainNamingContext: | cut -d " " -f 2)
echo $baseconf

echo "Building attributes list"
ldapsearch -R $5 -h $2.$DOMAIN -E pr=10000/noprompt -Y GSSAPI -b "${baseconf}" CN | grep cn | cut -d " " -f 2 | grep -iE 'password|pwd|creds|cred|secret' | grep -vEi 'count|set|time|age|length|propertie' | sort | uniq  > $DOMAIN-keywords.txt
sed -i 's/-//g' $DOMAIN-keywords.txt

echo -n "Analyzing domain " 
echo -e "${ORANGE}${DOMAIN^^}${NC}"
IFS='.' read -r -a array <<< "$DOMAIN"
for x in ${!array[@]}; do
   base="${base}DC=${array[x]},"
done

for KEYWORD in $(cat $DOMAIN-keywords.txt)
do
  filter+="(${KEYWORD}=*)" 
done
filter+=")"

echo -e "${RED}****These are supposed to be interesting results: ****${NC}"
ldapsearch -R $5 -h $2.$DOMAIN -E pr=10000/noprompt -Y GSSAPI -b "${base::-1}" "${filter}" > $DOMAIN-enum.txt
echo "" 
cat $DOMAIN-enum.txt | grep -i -f $DOMAIN-keywords.txt | grep -ivE 'filter|objectclass'
echo "" 
echo "**** Results are on disk, enumerating next DC **** "
