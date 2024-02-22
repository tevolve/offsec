#!/bin/bash

## Verifica se o argumento foi passado
if [ "$1" == "" ]; then
   # Se não passou argumento, informa e sai do script
   echo "Informe a rede alvo, exemplo: 192.168.0"
   exit 1
fi

## Verifica se é root
if [ $EUID -ne 0 ]; then
   # Se não for root, informa e sai do script
   echo "Execute como root, exemplo: sudo ./script.sh 192.168.0"
   exit 1
fi

## Define a lista de portas a serem verificadas
portas=(33024 33054 43001 44289 49222)

## Inicia o loop
echo "## Iniciando testes, aguarde. . ."
for ip in {1..255}
do
   current_ip="$1.$ip"

   echo "==> Testando IP $current_ip"

   for porta in "${portas[@]}"; do
       hping3 $current_ip -S -c 1 -p $porta > /dev/null 2>&1
   done

   # Exemplo de requisição HTTP com curl
   # curl "http://$current_ip:1337/" -m .5 > /dev/null 2>&1
done
