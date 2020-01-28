#!/bin/bash
# ver 1.3 arch

usbinst=0
hdn=$(whoami)

if [ "$usbinst" = 0 ]; then
clear
	echo
	echo "Welcome to install USB install flash."
	echo
		lsblk
	echo
	#Выбираем USB накопитель
	echo "Enter your usb disk. Example /dev/sda." 
		read -p	"USB disk: /dev/" usbdevice
	echo
	#Предупреждение
	echo "Attention!!! All data on usb will be destroy and recovery is not possible!!!"
	#Удаление всех данных с диска
	echo "Delete all data on /dev/$usbdevice. Please wait..." 
	echo
		echo "mkdir -p /mnt/usb"
		mkdir -p /mnt/usb
		echo "umount /dev/$usbdevice"
		umount /dev/$usbdevice'1'
		lsblk
		wipefs --all --force /dev/$usbdevice
		dd if=/dev/zero of=/dev/$usbdevice bs=446 count=1
		partprobe
		sync
	echo
	#Создание раздела на устройстве
	echo "Create partition to /dev/$usbdevice" 
	echo
	#Название флешки
		read -p "Enter the USB device name: " usbname
		(echo o;echo n;echo p;echo 1;echo ;echo ;echo a;echo w) | fdisk /dev/$usbdevice
		mkfs.ext4 -L $usbname /dev/$usbdevice'1'
		sync
	echo
	#Создание дирректорий 
	echo "Create folders and mnount /dev/$usbdevice'1'"
	echo
		mkdir -p /mnt/usb
	#Монтирование флешки в созданную дирректорию в /mnt/usb
		echo "mount /dev/$usbdevice partition to /mnt/usb"
		mount /dev/$usbdevice'1' /mnt/usb
	#Создаем на флешке дирректории
		echo "mkdir -p /mnt/usb/boot/syslinux"
			mkdir -p /mnt/usb/boot/syslinux
		echo "mkdir -p /mnt/usb/proc"
			mkdir -p /mnt/usb/proc
		echo "mkdir -p /mnt/usb/sys"
			mkdir -p /mnt/usb/sys
		echo "mkdir -p /mnt/usb/tmp"
			mkdir -p /mnt/usb/tmp
		echo "mkdir -p /mnt/usb/run"
			mkdir -p /mnt/usb/run
		echo "mkdir -p /mnt/usb/var/lib/pacman"
			mkdir -p /mnt/usb/var/lib/pacman
		echo "mkdir -p /mnt/usb/ISO"
			mkdir -p /mnt/usb/ISO
	echo
	#Установка extlinux и метки загрузочного сектора
	echo "Install MBR and extlinux loader. Please wait..." 
	echo
		extlinux --install /mnt/usb/boot/syslinux
		echo
		dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/bios/mbr.bin of=/dev/$usbdevice
		sync
		cp -rv /boot/{initramfs-linux-fallback.img,initramfs-linux.img,vmlinuz-linux} /mnt/usb/boot
		cp -rv /usr/lib/syslinux/bios/memdisk /mnt/usb/boot/syslinux
		sync
	echo
	#Установка системы на флешку
	echo "Install system to /dev/$usbdevice."
	echo
		pacstrap /mnt/usb base base-devel dhcpcd dialog wpa_supplicant --noconfirm
		genfstab -L /mnt/usb >> /mnt/usb/etc/fstab
	echo
	#Заходим (чрутимся) в флешку
	echo "Chroot to /mnt/usb."
		cp -rv /home/build/usbbuild/1.3/usb_ver_1_3_in_progress.sh /mnt/usb/root/
		sed -i '4 s/usbinst=0/usbinst=1/g' /mnt/usb/root/usb_ver_1_3_in_progress.sh
		arch-chroot /mnt/usb /bin/bash -c /root/usb_ver_1_3_in_progress.sh
	echo
	#Запись UUID USB флешки в файл syslinux.cfg
	echo "Change 'root=/dev/sda1' to 'UUID' usb device in syslinux.cfg."
		lsblk -i -d -n -l -o KNAME,TYPE,MODEL,HOTPLUG
		echo
		read -p "Enter the name USB disk. Example sdb,sdc: " usbdev
		sed -n '54p' /mnt/usb/boot/syslinux/syslinux.cfg
		blkid -s UUID /dev/$usbdev'1'
	echo
		read -p "Past 'UUID' USB device: " usid
		sed -i -e '54 s$/dev/sda1$'$usid'$g' /mnt/usb/boot/syslinux/syslinux.cfg
		sed -n '54p' /mnt/usb/boot/syslinux/syslinux.cfg
	echo
	#Удаляем ненужные файлы
	echo  "Deleting unnecessary files. Please wait..."
	echo
	echo  "/mnt/usb/proc/*"
		rm -rf /mnt/usb/proc/*
	echo  "/mnt/usb/sys/*"
		rm -rf /mnt/usb/sys/*
	echo  "/mnt/usb/tmp/*"
		rm -rf /mnt/usb/tmp/*
	echo  "/mnt/usb/run/*"
		rm -rf /mnt/usb/run/*
	echo  "/mnt/usb/root/usb_ver_1_3_in_progress.sh"
		rm /mnt/usb/root/usb_ver_1_3_in_progress.sh
	#Обновление системы и синхронизация данных на hdd/usb
	echo  "sync...please wait..."
		sync
	echo
	#Размонтируем устройство
	echo "Umount /dev/$usbdevice"
		umount -R /mnt/usb/
	#Изменяем права папки с вложенными файлами (на всякий случай, если не получиться удалить папку /usb из дирректории /mnt)
		chattr -i /mnt
	echo  "Delete /mnt/usb"
		sudo rm -rf /mnt/*
	echo
	#Завершение установки и настройки флешки
	echo "Done. Exit script."
fi

if [ "$usbinst" = 1 ]; then
	clear
	echo
	#Конфигурирование системы
	echo  "Configure install system." 
	echo
	#Установка и настройка загрузчика и ядра
	echo  "Install kernel." 
		pacman -S arch-install-scripts mkinitcpio mkinitcpio-utils mkinitcpio-nfs-utils linux linux-firmware linux-headers --noconfirm
	#Установка загрузчика в установленной системе
	echo  "Install syslinux loader." 
		pacman -S gptfdisk syslinux mtools --noconfirm
		syslinux-install_update -i -a -m
	echo
	#Конфигурирование локалей
	echo  "Configure locales." 
		sed -i -e '176 s/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/g' /etc/locale.gen
		sed -i -e '401 s/#ru_RU.UTF-8\ UTF-8/ru_RU.UTF-8\ UTF-8/g' /etc/locale.gen
		sleep 1
		locale-gen
		export LANG=ru_RU.UTF-8
		echo LANG=ru_RU.UTF-8 > /etc/locale.conf
		loadkeys ru
	echo
	#Терминальные шрифты и время
	echo  "Terminal fonts and time." 
	echo
	echo "cyr-sun16"
		setfont cyr-sun16
	echo "KEYMAP=ru"
		echo 'KEYMAP=ru' >> /etc/vconsole.conf
	echo "FONT=cyr-sun16"
		echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
	#Временная зона
	echo  "Timezone Moscow." 
	  	ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
	#Настройка даты
	echo "timedatectl"
		timedatectl set-ntp true
	#Настройка времени
	echo "hwclock"
		hwclock --systohc --utc
	echo
	#Конфигурирование ядра системы
	echo "Configure kernel." 
		mkinitcpio -p linux
	echo
	#Установка окружения рабочего стола как в Windows
	echo "Install xfce4"
		pacman -S xfce4 xfce4-goodies --noconfirm
	echo
	#Установка включение логин менеджера
	echo "Install LightDM"
		pacman -S lightdm lightdm-gtk-greeter lightdm lightdm-gtk-greeter-settings --noconfirm
		sleep 2
	echo  "systemctl enable lightdm"
		systemctl enable lightdm
	echo
	#Установка и включение ssh и сетевых библиотек
	echo "Install netctl and openssh"
		pacman -S net-tools netctl --noconfirm
		pacman -S openssh --noconfirm
	echo  "systemctl enable sshd"
		systemctl enable sshd
	echo
	#Установка видео драйверов
	echo "Install xorg"
		pacman -S xorg-server xorg-server-common xorg-xinit --noconfirm
		pacman -S  xf86-input-evdev xf86-input-libinput xf86-video-intel xf86-video-nouveau --noconfirm
		pacman -S fontconfig gtk3 gtk2 --noconfirm
	echo
	#Установка программ
	echo "Install programms"
		pacman -S mc htop nano filezilla firefox gvfs gvfs-smb smartmontools ntfs-3g --noconfirm
	echo
	#Имя флешки
	echo "USB device name." 
		read -p "USB name: " uhost
		echo $uhost > /etc/hostname
	echo
	#Создание нового пользователя
	echo  "New user."
		read -p "User name: " uname
	#Добавление пользователя в группы
	echo "Added $uname in groups. Please wait..." 
		groupadd autologin
		useradd -m -g users -G ftp,network,users,nobody,wheel,audio,disk,storage,video,autologin -s /bin/bash $uname
	#Пароль нового пользователя
		passwd $uname 
	#Добавление пользователя в рут (даем пользователю права запускать установку/обновление без запроса пароля)
	echo "Now user $uname will be added in sudoers..." 
		echo ''$uname' ALL=(ALL) ALL' >> /etc/sudoers 
		echo ''$uname' ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
	echo
	#Изменение conf файла lightdm
	echo "Some config LightDM. Please wait..." 
		sed -i -e '88 s/#pam-service=lightdm/pam-service=lightdm/g' /etc/lightdm/lightdm.conf
		sed -i -e '89 s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g' /etc/lightdm/lightdm.conf
		sed -i -e '102 s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/g' /etc/lightdm/lightdm.conf
		sed -i -e '103 s/#greeter-hide-users=false/greeter-hide-users=true/g' /etc/lightdm/lightdm.conf
		sed -i -e '105 s/#greeter-show-manual-login=false/greeter-show-manual-login=true/g' /etc/lightdm/lightdm.conf
		sed -i -e '107 s/#user-session=/user-session=xfce.desktop/g' /etc/lightdm/lightdm.conf
		sed -i -e '109 s/#allow-guest=true/allow-guest=false/g' /etc/lightdm/lightdm.conf
		sed -i -e '120 s/#autologin-user=/autologin-user='$uname'/g' /etc/lightdm/lightdm.conf
		sed -i -e '121 s/#autologin-user-timeout=0/autologin-user-timeout=3/g' /etc/lightdm/lightdm.conf
	echo
	#Сообщение об успешном добавлении пользователя
	echo "User $uname successfuly added in sudoers users."
	echo
	#Пароль рута (суперпользователя)
	echo  "Root Password." 
		passwd
	echo
	#Раскомментирование репозтрория для x64 
	echo  "Configuring pacman.conf"
	echo  "Old"
		sed -n '92p' /etc/pacman.conf
		sed -n '93p' /etc/pacman.conf
		sudo sed -i -e '92 s!#!!g' /etc/pacman.conf
		sudo sed -i -e '93 s!#Include!Include!g' /etc/pacman.conf
	echo  "New"
		sed -n '92p' /etc/pacman.conf
		sed -n '93p' /etc/pacman.conf
		pacman -Sy
	echo
	echo  "Configuring syslinux.cfg. Please wait..." 
	#Изменение файла конфигурации загрузки, переименование и закомментирование пунктов меню в syslinux.cfg 
		sed -i -e '23 s/TIMEOUT\ 50/TIMEOUT\ 100/g' /boot/syslinux/syslinux.cfg
		sed -i -e '33 s/MENU\ TITLE\ Arch\ Linux/MENU\ TITLE\ Live\ USB\ ver.\ 1.3/g' /boot/syslinux/syslinux.cfg
		sed -i -e '52 s/MENU\ LABEL\ Arch\ Linux/MENU\ LABEL\ Live\ USB/g' /boot/syslinux/syslinux.cfg
		sed -i -e '54 s/sda3/sda1/g' /boot/syslinux/syslinux.cfg
		sed -i -e '54 s/rw/rw\ net.ifnames=0/g' /boot/syslinux/syslinux.cfg
		sed -i -e '57 s/LABEL/#LABEL/g' /boot/syslinux/syslinux.cfg
		sed -i -e '58 s/MENU/#MENU/g' /boot/syslinux/syslinux.cfg
		sed -i -e '59 s/LINUX/#LINUX/g' /boot/syslinux/syslinux.cfg
		sed -i -e '60 s/APPEND/#APPEND/g' /boot/syslinux/syslinux.cfg
		sed -i -e '61 s/INITRD/#INITRD/g' /boot/syslinux/syslinux.cfg
		sed -i -e '68 s/LABEL/#LABEL/g' /boot/syslinux/syslinux.cfg
		sed -i -e '69 s/MENU/#MENU/g' /boot/syslinux/syslinux.cfg
		sed -i -e '70 s/COM/#COM/g' /boot/syslinux/syslinux.cfg
	#Удаление SWAP (файл подкачки) из /etc/fstab
		sed -i '9d' /etc/fstab
		sed -i '8d' /etc/fstab		
	echo
	#Чистим кэш
	echo  "Clean cash" 
	echo  "/var/cache/pacman/pkg/*"
		pacman -Scc --noconfirm
	#Проверка соединение с интернетом и включение сетевого интерфейса
	echo  "Create internet connection"  
		systemctl enable dhcpcd@eth0
	#Выход из чрута
	echo  "Exit."
		exit
fi
