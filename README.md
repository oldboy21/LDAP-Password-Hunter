# LDAP Password Hunter

It happens that due to legacy services requirements or just bad security practices password are world-readable in the LDAP database by any user who is able to authenticate.  
LDAP Password Hunter is a tool which wraps features of getTGT.py (Impacket) and ldapsearch in order to look up for password stored in LDAP database. Impacket getTGT.py script is
used in order to authenticate the domain account used for enumeration and save its TGT kerberos ticket. TGT ticket is then exported in KRB5CCNAME variable which is used by 
ldapsearch script to authenticate and obtain TGS kerberos tickets for each domain/DC LDAP-Password-Hunter is ran for. Basing on the CN=Schema,CN=Configuration export results
a custom list of attributes is built and filtered in order to identify a big query which might contains interesting results. Results are shown and saved in a sqlite3 database.
The DB is made of one table containing the following columns: 

* DistinguishedName  
* AttributeName
* Value
* Domain 

Results are way more clean than the previous version and organized in the SQL DB. The output shows the entries found only if they are not in DB, so new entries pop up but the 
overall outcome of the analysis is still saved in a file with a timestamp.  

## Requirements

* [Ldapsearch](https://docs.ldap.com/ldap-sdk/docs/tool-usages/ldapsearch.html) 
* [Impacket](https://github.com/SecureAuthCorp/impacket)
* [Sqlite](https://www.sqlite.org/index.html)

## Usage

Be sure your krb5.conf file is clean and the domains.txt and conf.txt are filled properly. 

From the project folder:

```bash
./run.sh
```
Easy-peasy :)

# Credits 

* SecureAuthCorp: For the work on [Impacket](https://github.com/SecureAuthCorp/impacket) project
* Alberto Solino (@agsolino): For the work on kerberoast modules based on the Impacket framework
* [Restrospected](https://github.com/Retrospected): For helping out every Friday with debugging the code and brainstorming on new features
