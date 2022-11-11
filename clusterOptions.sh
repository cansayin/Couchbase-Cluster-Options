#!/bin/bash


#linkedin : https://www.linkedin.com/in/can-sayın-b332a157/
#cansayin.com

declare -rx SCRIPT=${0##*/}   # SCRIPT is the name of this script
declare -rx apt="/etc/apt"
declare -rx couchbase="/opt/couchbase/bin/couchbase-cli"
shopt  -s   -o    nounset
banner()
{
  echo "+------------------------------------------+"
  printf "| %-40s |\n" "`date`"
  echo "|                                          |"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"
}

banner "executing function inside the script"
 
PS3="Enter a number to execute a function:  "
function shellcheck {
if test ! -x  "$BASH" ;  then
   printf   "$SCRIPT:$LINENO:  please run this script with bash shell"
else
   printf  "$SCRIPT:$LINENO: bash shell is available"
fi
  }

  function aptpackage {
if  test ! -x  "$apt" ;  then
    printf   "$SCRIPT:LINENO:  please the command $apt is not available"
else
  printf  "$SCRIPT:$LINENO: please the command $apt is available on the system"
fi
}
   function  couchcli {
if test ! -x   "$couchbase" ;  then
   printf   "$SCRIPT:$LINENO:   please the command $couchbase is not available.You need it to run this script"
   /usr/bin/firefox couchbase.com/downloads
else
  printf  "$SCRIPT:$LINENO: please the command $couchbase tool is available"
fi
 }

  function update {
  
   timeout 2  ping google.com
}

  initialize-cluster  ()    
{
    read  -p "enter the hostname for the cluster  :" hostname
    read  -p "enter the username for the administrator user  :" username
    read  -p "enter the password for the administrator user  :" password
    read  -p "enter the memory quota in megabytes for the cluster  :" ramsize
    couchbase-cli cluster-init -c $hostname  --cluster-username $username  \
 --cluster-password $password  --cluster-ramsize $ramsize
 }

create-bucket   ()    
{ 
     read  -p  "enter the hostname for the cluster  : " hostname
     read  -p  "enter the username for administrator user   : "  username
     read  -p  "enter  the password for the administrator user  :" password
     read  -p  "enter the memory quota for the cluster  :"  ramsize
     couchbase-cli bucket-create -c $hostname  --username $username \
 --password $password --bucket $bucket  --bucket-type $btype \
 --bucket-ramsize $ramsize
} 

start-logs  ()    
{
     read  -p "enter the hostname for the cluster   :"  hostname
     read   -p "enter the username for the administrator    :"  username
     read  -p  "enter the  node to collect logs from    :"  node

    timeout 10  couchbase-cli  collect-logs-start  -c  $hostname  --username $username  --password $password  --nodes  $node
 } 

set-indexes   ()
{ 
     read  -p  "enter the hostname for the cluster            :"  hostname
     read  -p  "enter the username for the system administrator   :"   username
     read  -p  "enter the password of the system administrator    :"    password
     read  -p  "enter the maximum number of rollback points       :"    rollback
     read  -p  "enter the specified value for persisted snapshot for recovery in seconds   :"   recovery
     read  -p  "enter the specified value for the log level                         :"  loglevel
     couchbase-cli  setting-index  -c  $hostname  --username $username --password $password  --index-max-rollback-points  rollback  --index-log-level  $loglevel
     }

mail-alert   ()   
{
     read  -p  "enter the hostname for the cluster  :"  hostname
     read  -p  "enter the username for the system administrator  :"   username
     read  -p  "enter the password of the system administrator   :"   password
     read -p   "enter the number 1 to enable email alert   :"    mail
     read -p   "specify email user   :"    user
     read  -p  "specify the password of email us  :"    mpass
     read  -p  "specify the email server hostname  :"    mserver
     read  -p  "specify  the email server port  :"   mport
     read  -p  "Do you want to enable email encryption  :"   crypt
 couchbase-cli  setting-alert  -c  $hostname  --user  $username  --password $password --enable-email-alert $mail  --email-user $user  --email-password $mpass  --email-host $mserver
--email-port  $mport  --email-recipients  $receivers  --email-sender $sender  --enable-email-encrypt  $crypt
} 
  delete-bucket ()   
 { 
      #specify your host name
     read -p "enter host name: " host
     #specify your username
     read -p "enter username:  " name
     #specify username password
     read  -p "username password:   "  password
     #specify bucket name  
     read -p "enter bucket: "  bucket

   couchbase-cli bucket-delete  -c $host --username $name  --password  $password     --bucket  $bucket
}
select opts in "check for bash shell" "check for apt package manager" "check for couchbase-cli tool" "Update package in a repository" "Initialize a cluster in couchbase server" "Create a bucket in a couchbase cluster" "Collects logs in a couchbase cluster" "Set indexes in a couchbase cluster" "Enable mail alert in a couchbase cluster" "Delete a bucket in the cluster" "exit script"
do
        case $opts in
                "check for bash shell")
                             echo -e "\e[0;32m $(shellcheck) \e[m"
                             ;;
                "check for apt package manager")
                             echo -e "\e[0;32m $(aptpackage) \e[m"
                             ;;
                "check for couchbase-cli tool")
                              echo -e "\e[0;32m $(couchcli) \e[m"
                              ;;
                "Update package in a repository")
                              echo -e "\e[0;32m $(update) \e[m"
                              ;;
                                           
 "Initialize a cluster in couchbase server")
                                echo -e "\e[0;32m $(initialize-cluster) \e[m"
                                ;;
                "Create a bucket in a couchbase cluster")
                                echo -e "\e[0;32m $(create-bucket) \e[m"
                                ;;
                 "Collects logs in a couchbase cluster")
                                echo -e "\e[0;32m $(start-logs) \e[m"   
                                ;;
                 "Set indexes in a couchbase cluster")
                                echo -e "\e[0;32m $(set-indexes) \e[m" 
                                ;;
                 "Enable mail alert in a couchbase cluster")
                                echo -e "\e[0;32m $(mail-alert) \e[m" 
                                ;;
                 "Delete a bucket in the cluster")
                                echo -e "\e[0;32m $(delete-bucket) \e[m" 
                                ;;
                "exit script")
                                break
                                ;;
                *)
                                echo "invalid option"
                                ;;
        esac
done
