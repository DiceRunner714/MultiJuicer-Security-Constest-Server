#!/bin/bash

echo -e "\e[1;34m==========================================\e[0m"
echo -e "\e[1;32m Iniciando Setup do MultiJuicer - FCTE\e[0m"
echo -e "\e[1;34m==========================================\e[0m"

echo -e "\n\e[1;33m[1/7] Instalando dependências (Helm)...\e[0m"
sudo snap install helm --classic

echo -e "\n\e[1;33m[2/7] Instalando K3s...\e[0m"
curl -sfL https://get.k3s.io | sh -

echo -e "\n\e[1;33m[3/7] Configurando permissões do Kubeconfig...\e[0m"
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

echo -e "\n\e[1;33m[4/7] Aguardando 15 segundos para o cluster estabilizar...\e[0m"
sleep 15
kubectl get nodes

echo -e "\n\e[1;33m[5/7] Instalando MultiJuicer com Helm...\e[0m"
helm install multi-juicer oci://ghcr.io/juice-shop/multi-juicer/helm/multi-juicer \
  --namespace multi-juicer \
  --create-namespace \
  --set balancer.config.maxInstances=15 \
  --set balancer.ui.title="FCTE - Security Challenge" \
  --set balancer.ui.theme="orange"

echo -e "\n\e[1;33m[6/7] Aguardando criação dos recursos e aplicando Ingress...\e[0m"
sleep 10
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-juicer-ingress
  namespace: multi-juicer
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: multi-juicer
            port:
              number: 8080
EOF

echo -e "\n\e[1;33m[7/7] Resgatando a senha de Administrador...\e[0m"
sleep 5
ADMIN_PASS=$(kubectl get secrets multi-juicer-secret --namespace="multi-juicer" -o=jsonpath='{.data.adminPassword}' | base64 --decode)
IP_ATUAL=$(ip route get 1.1.1.1 | awk '{print $7}')

echo -e "\n\e[1;34m==========================================\e[0m"
echo -e "\e[1;32m AMBIENTE IMPLANTADO COM SUCESSO!\e[0m"
echo -e "\e[1;34m==========================================\e[0m"
echo -e "URL dos Participantes : \e[1;36mhttp://${IP_ATUAL}\e[0m"
echo -e "URL do Painel Admin   : \e[1;36mhttp://${IP_ATUAL}/balancer/\e[0m"
echo -e "Usuário Admin         : \e[1;37madmin\e[0m"
echo -e "Senha Admin           : \e[1;31m${ADMIN_PASS}\e[0m"
echo -e "\e[1;34m==========================================\e[0m"

echo -e "Rode ~ export KUBECONFIG=~/.kube/config"
