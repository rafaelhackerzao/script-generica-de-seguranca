#!/bin/bash

echo "Bem vindo a script de seguranca escrita por mim, Joao pedro amorim gamer";
echo "Ok. Vamos comecar. Ja irei falando que esta script so serve para sistemas baseado em Arch Linux.";
echo "Voce vai querer configurar um firewall e aplicar as minhas configuracoes? (s/n): "

# le o que o usuario botou e insere em uma variavel chamada SIM_OU_NAO
read SIM_OU_NAO;

#Se a variavel SIM_OU_NAO e igual a "s", entao faca isso:
if [ $SIM_OU_NAO == s ]; then
	echo "A script ira instalar um firewall chamado UFW. Instale-o.";
	sleep 1;
	sudo pacman -S ufw;
	echo -n "Firewall instalado. Voce deseja usar ou planeja usar ssh? (s/n): ";
	read DESEJA_USAR_SSH;
	if [[ DESEJA_USAR_SSH == s ]]; then
		echo "OK. Aplicando configuracoes...";
		sudo ufw default allow outgoing;
		sudo ufw default deny incoming;
		sudo ufw allow ssh; # Permitir conexoes ssh
		sudo ufw allow ssh/tcp;
		sudo ufw allow http; # Permitir conexoes http
		sudo ufw allow https;
		sudo ufw allow http/tcp;
		sudo ufw allow https/tcp;
		sudo ufw enable; # Ativa o UFW
		echo "Configuracoes de Firewall aplicadas. indo para o proximo passo."
	else
		echo "OK. Aplicando configuracoes...";
		sudo ufw default allow outgoing;
		sudo ufw default deny incoming;
		sudo ufw deny ssh; # Bloqueia conexoes ssh
		sudo ufw allow http; # Faca que o UFW permita conexoes de http (para acessar sites da Internet)
		sudo ufw allow http/tcp;
		sudo ufw enable; # Ativa o UFW
		echo "Configuracoes de Firewall aplicadas. Indo para o proximo passo."
	fi
else
	# Voce NAO QUER UM FIREWALL????!!!
	echo "Bem... Ok?";	

fi

echo -n "Voce deseja usar o kernel linux-hardened? Ele aplica alguns patches de seguranca no kernel original e pode aumentar sua seguranca. (s/n): "
# Le o que o usuario digitou (Nesse caso "s" ou "n", e guarda o valor na variavel.
read KERNEL_HARDENED;

if [ $KERNEL_HARDENED == "s" ]; then
	echo "Voce tera um prompt do Pacman para instalar o kernel. Instale-o.";
	sudo pacman -S linux-hardened linux-hardened-headers; # Diz para o Pacman instalar linux-hardened e linux-hardened-headers
	sudo grub-mkconfig -o /boot/grub/grub.cfg;
	echo "Kernel linux-hardened instalado. Apos a script terminar, reinicie o computador, e quando o menu do Grub aparecer, va em mais opcoes e selecione linux-hardened.";
else
	echo "Bem.. ta bom entao ne?";
fi

echo "Aplicando algumas configuracoes finais...";
cd /etc/sysctl.d/;
echo "net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
net.ipv4.tcp.syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0" > 99-network.conf;

sudo sysctl --system;

echo "Configuracoes aplicadas. Voce quer instalar um gerenciador de senhas? Ele consegue armazenar suas senhas com seguranca, mas a minha recomendacao seria o KeepassXC. (s/n): ";
read QUER_GERENCIADOR;

if [ $QUER_GERENCIADOR == s ]; then
	echo "OK. Como antes, vai abrir um prompt do Pacman perguntando se voce quer instala-lo.";
	sudo pacman -S keepassxc;
	echo "KeepassXC instalado.";
else
	echo "Ta bom entao.";
fi
