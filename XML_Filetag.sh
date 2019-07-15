#!/bin/bash

#########################################################################################
#                                                                                       #
#       File  : ./XML_Filetag.sh                                                        #
#       Usage : ./XML_Filetag.sh                                                        #
#       Description : Extract files from XML and search them on FTP server              #
#       Requirement : Floppy(USB)                                                       #
#       Bugs   : None                                                                   #
#       Author : Mouad OURGH                                                            #
#       Version: 1.0                                                                    #
#       Date   : 16/01/2019                                                             #
#                                                                                       #
#########################################################################################
xml=$1
file_count=$(sed 's|^<FileName>\(.*\)</FileName>$|\1|' file.xml)
read -p "Enter the hostname : " HOST
HOST=demo.wftpserver.com            
read -p "Enter your username : " LOGIN
LOGIN=demo-user                       
read -s -p  "Enter your password : " PASSWORD
echo
PASSWORD=demo-user
RESET="\033[0m"
RED="\033[31;1m"
YELLOW="\e[33;1m"
GREEN="\e[32;1m"
yum list installed | grep -i lftp &> /dev/null || yum install lftp -y &> /dev/null
#Delete/Create playlists
function playlist {
for i in $file_count
	do	
		#file=$(sed -n '/<FileName>/,/<\FileName>/p' $i)
		if [ -f downloaded.txt ];then
			#echo $i
			if [[ $(grep $i downloaded.txt) ]];then
				rm -f downloaded.txt
			fi
		else
			touch downloaded.txt
		fi		
	done
}
#Searching files
function file_search {

#lftp -c 'open -e "set ssl:verify-certificate no; find ./ | grep << EOF quote $file EOF" ftp://demo-user:demo-user@demo.wftpserver.com:21'

output=$(lftp demo-user:demo-user@demo.wftpserver.com << EOF
set ssl:verify-certificate no
find ./ | grep $file
EOF
) &> /dev/null 
}
#Downloading files
function file_download {

lftp demo-user:demo-user@demo.wftpserver.com << EOF
set ssl:verify-certificate no
pget $output
EOF

}

function find_file {

for i in $file_count
	do
		#file=$(sed -n '/<FileName>/,/<\FileName>/p' $i)
			if [ $(ls $i 2> /dev/null) ];then
				echo -e "${GREEN}$i available $RESET"
			else
				echo -e "$RED$i not available $RESET"
				file=$(echo "$i" | awk -F"/" '{print $NF}')
				#download #file from FTP server
				file_search &> /dev/null || echo -e "${RED}Connection to FTP Server Failed $RESET" ; exit
				if [ -z $output ];then
				        echo -e "$YELLOW$i not available in the FTP server$RESET"
        				continue
				fi
				file_download
				mv $file $i
				echo "$i were downloaded" >> downloaded.txt
			fi
	done

}
playlist
find_file
