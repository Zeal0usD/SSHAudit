#!/bin/bash

##
# SSH internal audit
#   - Check authentication logs for failed logins
#   - Check user sudo command history
#   - Check bash history
#   - Panic button to kill user session 
##

server_name=$(hostname)

function flogin_check() {
    echo ""
	echo "Failed logins on ${server_name} are: "
	egrep "Failed|Failure" /var/log/auth.log
	echo ""
}

function userhistory_check() {
echo "Please enter the username:"
read uname
echo ""
	echo "History of $uanme on ${server_name}: "
    echo ""
	tail /var/log/auth.log | grep $uname
    echo ""
}

function bashhistory_check() {
    echo "Please enter the username:"
read uname
	echo "Bash history of $uname on ${server_name}: "
    echo ""
	sudo nano /home/$uname/.bash_history
    echo ""
}

function panic_check() {
	w
	echo "Type the username to kill the remote session"
	read uname
	echo "kill user session on ${server_name}: "
	sudo killall -u $uname
    echo ""
}

function all_checks() {
	flogin_check
	userhistory_check
	bashhistory_check
	panic_check
}

##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

menu(){
echo -ne "
SSH Internal Audit
$(ColorGreen '1)') Check failed logins
$(ColorGreen '2)') User Command History
$(ColorGreen '3)') Bash History of User
$(ColorGreen '4)') Panic Kill User Session
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) flogin_check ; menu ;;
	        2) userhistory_check ; menu ;;
	        3) bashhistory_check ; menu ;;
	        4) panic_check ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
