#!/bin/bash
#rev 1.1 ubuntu-server 18.04

clear

archivename=old_TrinityCore_from-
PING=github.com #адрес пингуемого сайта
uchoice=0 #переменя для ввода пользователем
un=$(whoami) #имя пользователя
ud=$(date) #текущая дата
userdate=$(date +%d.%m.%y) #текущая дата

function menu() {
clear
		echo
		echo -e "\e[1;92m \tWelcome '$un' to install and update the World of Warcraft server (version 1.1). \e[0m"
		echo
		echo -e "\e[1;94m \tChoice what you want to do: \e[0m"
		echo
		echo -e "\e[1;31m \t	Install libs \e[0m"
		echo -e "   1.Installing libraries for the server"
		echo -e "\e[1;31m \t	Download and install \e[0m"
		echo "   2.Download and install WoW WotLK server (ver. 3.3.5a 12340)"
		echo -e "\e[1;31m \t	Archive and update \e[0m"
		echo "   3.Archive and update WoW WotLK server (ver. 3.3.5a 12340)"
		echo -e "\e[1;31m \t	Extract and copy maps \e[0m"
		echo "   4.Export maps for WoW WotLK client (ver. 3.3.5a 12340)"
		echo -e "\e[1;31m \t	Configuring configuration files \e[0m"
		echo "   5.Configuring world server startup and authentication startup files"
		echo -e "\e[1;31m \t	Test internet connection \e[0m"
		echo "   6.Ping Github"
		echo -e "\e[1;31m \t	Exit script \e[0m"
		echo "   7.Exit"
		echo -e "\e[1;31m \t	In progress \e[0m"
		echo -e "\e[1;95m \tWoW Legion (ver. 7.2.5): download,install,update,export maps,archive \e[0m"
		echo -e "\e[1;95m \tWoW refreshable (ver. master): download,install,update,export maps,archive \e[0m"
		echo
		read -p "Enter your choice: " uchoice
		echo
			if [ "$uchoice" == "1" ]; then
                                inlib
			elif [ "$uchoice" == "2" ]; then 
				installWotLK
			elif [ "$uchoice" == "3" ]; then
			 	updateWotLK	
			elif [ "$uchoice" == "4" ]; then
				exportWotLK
			elif [ "$uchoice" == "5" ]; then
				ccf
			elif [ "$uchoice" == "6" ]; then
			 	checkinternet
			elif [ "$uchoice" == "7" ]; then
				exitscript	
			else
			     ers
			fi
}

function inlib() {
if [ "$uchoice" == "1" ];
        then
        clear
		echo
        echo "The packages required for server / server operation will now be installed"
        echo
		sudo apt-get install dialog zenity geany geany-plugins git gitk gcp clang cmake make gcc g++ libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mysql-server p7zip htop unrar engrampa pv subversion -y
		sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
		sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
		sleep 2
		echo
menu
fi
}

function installWotLK() {
if [ "$uchoice" == "2" ]; 
	then
		clear
		echo
		echo -e "\e[1;92m \tWelcome to install Trinity Core for World of Warcraft Wrath of the Lich King "
		echo
		echo -e "\e[1;94m \t   Now the server folder will be created in the HOME directory \e[0m"
		mkdir ~/server
		sleep 1
		cd ~/server
		echo
		echo -e "\e[1;92m \tClone Trinity Core from GitHub \e[0m"
		echo
		git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git
		echo
		echo -e "\e[1;92m \tCreate build directory in Trinity Core \e[0m"
		mkdir ~/server/TrinityCore/build
		cd ~/server/TrinityCore/build
		echo
		echo -e "\e[1;95m \tCompilation Core server \e[0m"
		echo
		cmake ../ -DCMAKE_INSTALL_PREFIX=~/server
		echo
		read -p "Enter the number of cores to compile: " ucores
		make -j $ucores
		make install
		echo
		echo -e "\e[1;31m \tCreate folders with logs, data, updates, archive and client \e[0m"
		mkdir ~/server/data
		mkdir ~/server/log
		mkdir ~/server/updates
		mkdir ~/server/archive
		mkdir ~/server/client
		echo
		echo -e "\e[1;92m \tCompilation complete \e[0m"
		echo -e "\e[1;92m \tInstall completed \e[0m"
		echo
		sleep 3
menu
fi
}

function updateWotLK() {
if [ "$uchoice" == "3" ]; 
	then
		secondupdate
		ccf2
	else 
		ers
menu
fi
}

function secondupdate() {
		clear
		echo
		echo -e "\e[1;92m \tWelcome to update Trinity Core for World of Warcraft Wrath of the Lich King \e[0m"
		echo
		echo -e "\e[1;94m \tArchiving the old TrinityCore from 'home/$un/server' to '/home/$un/server/archive' \e[0m"
		echo -e "\e[1;94m \tCreate TEMP directory in '/home/$un/server/archive' and copy the files 'bin,etc,log,TrinityCore' \e[0m"
		echo
		mkdir ~/server/archive/temp
		sleep 2
		cd ~/server
		gcp -rf ~/server/bin ~/server/archive/temp 
		gcp -rf ~/server/etc ~/server/archive/temp 
		gcp -rf ~/server/log ~/server/archive/temp 
		gcp -rf ~/server/TrinityCore ~/server/archive/temp
		echo
		echo -e "\e[1;91m \tDelete old TrinityCore from 'home/$un/server' and archive the old TrinityCore in '/home/$un/server/archive' \e[0m"
		rm -rf ~/server/{bin,etc,log,TrinityCore}
		cd ~/server/archive/temp
		tar -cf - . | pv -cN PACK_OLD_TRINITYCORE -s $(du -sb | grep -o '[0-9]*') | gzip > ../$archivename$userdate.tar.gz
		echo -e "\e[1;91m \tRemove TEMP dir in '/home/$un/server/archive' \e[0m"
		rm -rf ~/server/archive/temp
		echo
		echo -e "\e[1;92m \tArchiving done \e[0m"
		sleep 3
		clear
		echo
		echo -e "\e[1;91m \tTrinityCore update started \e[0m" 
		mkdir ~/server/updates/update_from_$userdate
		sleep 1
		cd ~/server/updates/update_from_$userdate
		echo -e "\e[1;94m \tClone Trinity Core from GitHub \e[0m"
		echo
		git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git
		echo
		echo -e "\e[1;92m \tCreate build directory in Trinity Core \e[0m"
		mkdir ~/server/updates/update_from_$userdate/TrinityCore/build
		cd ~/server/updates/update_from_$userdate/TrinityCore/build
		echo -e "\e[1;91m \tCompilation Core server \e[0m"
		cmake ../ -DCMAKE_INSTALL_PREFIX=~/server
		echo
		make -j 2
		make install
		mkdir ~/server/log
		echo
		echo -e "\e[1;92m \tCompilation complete \e[0m"
		sleep 1
		echo
		echo -e "\e[1;91m \tCopy new updated server \e[0m"
		echo -e "\e[1;94m \tCopy new TrinityCore from 'home/$un/server' \e[0m"
		echo
		gcp -rf ~/server/updates/update_from_$userdate/TrinityCore ~/server
		echo
		echo -e "\e[1;92m \tCopy and update completed \e[0m"
		sleep 3
}

function ccf2() {
			echo
			read -p "Enter the name your '/home/*****' path: " unp
			echo $unp > $un
			echo 
			echo -e "\e[1;94m \tConfiguring and rename 'authserver.conf' and 'worldserver.conf' \e[0m"
			cd ~/server/etc
#Переименовывание конфигурационных файлов для сервера
			cp authserver.conf.dist authserver.conf
			cp worldserver.conf.dist worldserver.conf
#Конфигурирования сервера аутентификации
			sed -i -e '42 s/ = ""/ = "\/home\/$un\/server\/log"/g' ~/server/etc/authserver.conf
			sed -i -e '157 s/ = ""/ = "\/home\/$un\/server\/TrinityCore"/g' ~/server/etc/authserver.conf
			sed -i -e '168 s/ = ""/ = "\/usr\/bin\/mysql"/g' ~/server/etc/authserver.conf
			sed -i -e '246 s/= 0/= 1/g' ~/server/etc/authserver.conf
#Конфигурирование игрового сервера
			sed -i -e '75 s/ = "."/ = "\/home\/$un\/server\/data"/g' ~/server/etc/worldserver.conf
			sed -i -e '84 s/ = ""/ = "\/home\/$un\/server\/log"/g' ~/server/etc/worldserver.conf
			sed -i -e '181 s/ = ""/ = "\/usr\/bin\/cmake"/g' ~/server/etc/worldserver.conf
			sed -i -e '190 s/ = ""/ = "\/home\/$un\/server\/TrinityCore\/build"/g' ~/server/etc/worldserver.conf
			sed -i -e '199 s/ = ""/ = "\/home\/$un\/server\/TrinityCore"/g' ~/server/etc/worldserver.conf
			sed -i -e '210 s/ = ""/ = "\/usr\/bin\/mysql"/g' ~/server/etc/worldserver.conf
			sleep 1
			sed -i -e '42 s/$un/'$unp'/g' ~/server/etc/authserver.conf
			sed -i -e '157 s/$un/'$unp'/g' ~/server/etc/authserver.conf
			sed -i -e '168 s/$un/'$unp'/g' ~/server/etc/authserver.conf
			sed -i -e '246 s/$un/'$unp'/g' ~/server/etc/authserver.conf
#Замена переменныхв файлах worldserver и authserver
			sed -i -e '75 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '84 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '181 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '190 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '199 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '210 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
		echo
		cd
		cd 'Рабочий стол'
		rm -rf $unp 
		echo -e "\e[1;94m \tConfiguring and rename 'authserver.conf' and 'worldserver.conf' done \e[0m"
		sleep 4
menu
}	

function exportWotLK() {
if [ "$uchoice" == "4" ]; 
	then
		clear
		echo
		echo -e "\e[1;92m \tWorld of Warcraft clinet (version 3.3.5a 12340) \e[0m"
		echo
		cd ~/server/client
		echo -e "\e[1;91m \tExctract 'dbc,maps' \e[0m"
		/home/$un/server/bin/mapextractor
		echo -e "\e[1;91m \tExtract 'vmaps,mmaps' \e[0m"
		~/server/bin/vmap4extractor
		~/server/bin/vmap4assembler Buildings vmaps
		~/server/bin/mmaps_generator
		echo -e "\e[1;91m \tCopy 'dbc,maps,vmaps,mmaps' \e[0m"
		gcp -rf ~/server/client/dbc ~/server/data
		gcp -rf ~/server/client/maps ~/server/data
		gcp -rf ~/server/client/vmaps ~/server/data
		gcp -rf ~/server/client/mmaps ~/server/data
		echo -e "\e[1;91m \tDelete all extract maps \e[0m"
		rm -rf ~/server/client/dbc
		rm -rf ~/server/client/maps
		rm -rf ~/server/client/vmaps
		rm -rf ~/server/client/mmaps
		rm -rf ~/server/client/Buildings
		echo
		echo -e "\e[1;92m \tDone \e[0m"
		sleep 2
menu
fi
}

function ccf() {
if [ "$uchoice" == "5" ]; 
	then
		clear
			read -p "Enter the name your '/home/*****' path: " unp
			echo $unp > $un
			echo 
			echo -e "\e[1;94m \tConfiguring and rename 'authserver.conf' and 'worldserver.conf' \e[0m"
			cd ~/server/etc
#Переименовывание конфигурационных файлов для сервера
			cp authserver.conf.dist authserver.conf
			cp worldserver.conf.dist worldserver.conf
#Конфигурирования сервера аутентификации
			sed -i -e '42 s/ = ""/ = "\/home\/$un\/server\/log"/g' ~/server/etc/authserver.conf
			sed -i -e '157 s/ = ""/ = "\/home\/$un\/server\/TrinityCore"/g' ~/server/etc/authserver.conf
			sed -i -e '168 s/ = ""/ = "\/usr\/bin\/mysql"/g' ~/server/etc/authserver.conf
			sed -i -e '246 s/= 0/= 1/g' ~/server/etc/authserver.conf
#Конфигурирование игрового сервера
			sed -i -e '75 s/ = "."/ = "\/home\/$un\/server\/data"/g' ~/server/etc/worldserver.conf
			sed -i -e '84 s/ = ""/ = "\/home\/$un\/server\/log"/g' ~/server/etc/worldserver.conf
			sed -i -e '181 s/ = ""/ = "\/usr\/bin\/cmake"/g' ~/server/etc/worldserver.conf
			sed -i -e '190 s/ = ""/ = "\/home\/$un\/server\/TrinityCore\/build"/g' ~/server/etc/worldserver.conf
			sed -i -e '199 s/ = ""/ = "\/home\/$un\/server\/TrinityCore"/g' ~/server/etc/worldserver.conf
			sed -i -e '210 s/ = ""/ = "\/usr\/bin\/mysql"/g' ~/server/etc/worldserver.conf
			sleep 1
			sed -i -e '42 s/$un/'$unp'/g' ~/server/etc/authserver.conf
			sed -i -e '157 s/$un/'$unp'/g' ~/server/etc/authserver.conf
			sed -i -e '168 s/$un/'$unp'/g' ~/server/etc/authserver.conf
			sed -i -e '246 s/$un/'$unp'/g' ~/server/etc/authserver.conf
#Замена переменныхв файлах worldserver и authserver
			sed -i -e '75 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '84 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '181 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '190 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '199 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
			sed -i -e '210 s/$un/'$unp'/g' ~/server/etc/worldserver.conf
		echo
		cd
		cd 'Рабочий стол'
		rm -rf $unp 
		echo -e "\e[1;94m \tConfiguring and rename 'authserver.conf' and 'worldserver.conf' done \e[0m"
		sleep 4
menu
fi
}	

function checkinternet() {
if [ "$uchoice" == "6" ]; 
	then
		echo "Ping $PING"
		echo
		ping -c 3 $PING 1>/dev/null
		res=$?
			if [ "$res" == "0" ];
				then
					echo -e "\e[1;92m \t
[OK] \e[0m \e[1;94m \tConnection is good. The Network is UP \e[0m"
					echo -e "\e[1;94m \tPress [Enter] to return to the menu... \e[0m"
					read -n 1
				else 
					echo -e "\e[1;91m \t
[Fail] \e[0m \e[1;94m \tBad connection. Something went wrong and Network is Down \e[0m"
					echo -e "\e[1;94m \t	Press [Enter] to return to the menu... \e[0m"
					read -n 1
			fi
		echo
menu
fi
}

function exitscript() {
if [ "$uchoice" == "7" ]; 
	then
	clear
		echo
		echo -e "\e[1;32m \tThanks '$un' for using my script. Now the script will be exited \e[0m"
		echo
		echo -e "\e[1;32m \tSpecialist of the Department of information technology FSUE AGA(A) @Maksim Koldaev \e[0m"
		echo
		sleep 2
		clear
		exit 0
fi
}

function ers() { 
if [ "$uchoice" != "" ]; 
	then
		echo -e "\e[1;91m \t
[Fail] \e[0m \e[1;94m \tAttention '$un' !!! You choice an item that's not in the menu, or left the field empty, 
		or something went wrong. Press [Enter] to return to the menu and try again... \e[0m"
        echo -e "\e[1;94m \t	Press [Enter] to return to the menu... \e[0m"
		read -n 1
menu

elif [ "$uchoice" == "" ]; 
	then
		echo -e "\e[1;91m \t
[Fail] \e[0m \e[1;94m \tAttention '$un' !!! You choice an item that's not in the menu, or left the field empty, 
		or something went wrong. Press [Enter] to return to the menu and try again... \e[0m"
		read -n 1
menu
fi
}

######################
# Entry point  #
######################
menu
