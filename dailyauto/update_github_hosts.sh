#!/bin/bash

regex_ip="(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}"
wget https://github.com.ipaddress.com -O github.ipaddress.html
# wget https://stackoverflow.com.ipaddress.com -O github_stackoverflow.html
# wget https://fastly.net.ipaddress.com/github.global.ssl.fastly.net -O github_fastly_net.ipaddress.html
# wget https://github.com.ipaddress.com/codeload.github.com -O github_codeload.ipaddress.html

github_ip=$(echo $(cat github.ipaddress.html) | grep -Eoe "$regex_ip" | head -1)
# stackoverflow_ip=$(echo $(cat github_stackoverflow.html) | grep -Eoe "$regex_ip" | head -1)
# github_fastly_net_ip=$(echo $(cat github_fastly_net.ipaddress.html) | grep -Eoe "$regex_ip" | head -1)
# codeload_ip=$(echo $(cat github_codeload.ipaddress.html) | grep -Eoe "$regex_ip" | head -1)

if [ ! -f "/etc/hosts.back" ];then
        echo "备份hosts文件至/etc/hosts.back"
        sudo cp /etc/hosts /etc/hosts.back
else
        echo "备份文件/etc/hosts.back已存在"
fi

cp /etc/hosts.back /etc/hosts

echo "$github_ip github.com"

echo "#for github speedup" >> /etc/hosts
echo "$github_ip github.com" >> /etc/hosts
# echo "$stackoverflow_ip stackoverflow.com" >> /etc/hosts
# echo "$github_fastly_net_ip github.global.ssl.fastly.net" | sudo tee -a /etc/hosts
# echo "$codeload_ip codeload.github.com" | sudo tee -a /etc/hosts

echo "restart network..."
service nscd restart

# echo "rm tmp file..."
rm github*.html

echo
echo "enjoy~"
