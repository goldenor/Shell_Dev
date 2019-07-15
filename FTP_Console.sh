#!/bin/bash

#########################################################################################
#                                                                                       #
#       File  : ./FTP_Console.sh                                                        #
#       Usage : ./FTP_Console.sh                                                        #
#       Description : Authentification SSH 			                                        #
#       Option: 													                                              #
#       Requirement :                                              		    	            #
#       Bugs   : None                                                                   #
#       Author : Mouad OURGH                                                            #
#       Version: 1.0                                                                    #
#       Date   : 23/01/2019                                                             #
#                                                                                       #
#########################################################################################

function helpshow {

echo -e """***************************************************************************************\n\e[0;33mls [UNIX_ls_ARGUMENTS]:\e[0m UNIX ls with all supported options of your current ls app installed on your system \n \e[0;33mcd [UNIX_cd_ARGUMENTS]: \e[0mUNIX cd with all supported options of your current cd app installed on your system \n
\e[0;33msearch [OPTIONS] "REGEX":\e[0m search with desired option in the current directory with the REGEX entered \n \tif REGEX is null, it will be like simple ls commands \n\t\tOPTIONS => -R : means in current and all sub directories    \n\t\tOPTIONS => -C : means in current directory only    \n\t\tOPTIONS => not specified : works like -R\n
\e[0;33mdl ABSOLOUTE_PATH_TO_DESIRED_FILE ABSOLOUTE_PATH_TO_LOCAL_DESTINATION \n\e[0m\n\e[0;33mcleanup :\e[0m disconnects all the created connections to FTP server and reverts any other changes that program did and returns to the beginning of app \n\e[0;33mexit :\e[0m exits the program and cleanup \n\n\e[0;33mhelp :\e[0m shows this screen \n***************************************************************************************"""
}

function input_user {

arg1=$(echo ${choice} | cut -d" " -f1)
arg2=$(echo ${choice} | cut -d" " -f2)
arg3=$(echo ${choice} | cut -d" " -f3)

case $arg1 in 

    "ls")
		ls $arg2 || ls
	;;
    "cd")
		cd $arg2
		echo -e "\e[0;32mChanged directory!\e[0m"
        ;;
    "search")
		echo -e "\033[33mCollecting results\e[0m"
		echo -e "\e[0;32mHere are the results :\e[0m"
		if [[ $arg2=="-C" && ! -z "$arg3" ]];then
			dir -C $arg3 #will list the files in wide format.
		elif [[ $arg2=="-R" && ! -z "$arg3" ]];then
			dir -R $arg3 #lists all files in current directory and subdirectories.
		else
			dir -R #lists all files in current directory and subdirectories.	 
        	fi
	;;
	"dl")
		echo -e "\033[33mDownloading file ...\e[0m"
		mget $arg2 $arg3
		if [ $? -eq "0" ];then
			echo "\e[0;32mDone!\e[0m"
		fi
		;;
	"cleanup")
		echo -e "\033[33mCleaning up ... \e[0m"
		echo -e "\e[0;32mClean as a new!\e[0m"
		close
		;;
	"exit")
		echo -e "\e[0;32mbye!\e[0m"
		exit
		;;
    *)
		helpshow
        ;;
esac


}

echo "Welcome to FTPSearch!"
echo -e "\033[33mPlease enter the desired url of ftp website in the following format: foo.bar.foobar \e[0m "
read ftpserver
echo -e "\033[33mconnecting to the ftp server... \e[0m "
ftp $ftpserver 
	if [ $? -eq "0" ];then
	echo -e "\e[0;32mConnected!\e[0m"
	echo "type help to get list of commands!"
	helpshow
	#read choice
	while read choice 
	do
    	input_user
	done
	
else 
	echo -e "\e[01;31mNot connected! \e[0m"
	exit 10
fi

