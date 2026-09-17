#!/bin/bash

echo -e "\e[1;34m==========================================\e[0m"
echo -e "\e[1;32m Iniciando Limpeza do MultiJuicer - FCTE\e[0m"
echo -e "\e[1;34m==========================================\e[0m"

echo -e "\n\e[1;33m[1/1] Desinstalando dependências antigas...\e[0m"
sudo /usr/local/bin/k3s-killall.sh 2>/dev/null || true
sudo /usr/local/bin/k3s-uninstall.sh 2>/dev/null || true

sudo rm -rf /etc/rancher/
rm -rf ~/.kube/
rm -rf ~/.cache/helm/
rm -rf ~/.config/helm/

echo -e "\n\e[1;34m==========================================\e[0m"
echo -e "\e[1;32m LIMPEZA CONCLUIDA!\e[0m"
echo -e "\e[1;34m==========================================\e[0m"
