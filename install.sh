#!/bin/bash

echo "INASTALACIÓN DE COMPONENTES EN PROD"

BASEDIR=${PWD}
echo "Script location: ${BASEDIR}"

echo "Listado de carpetas node_modules a eliminar"
find . -name 'node_modules' -type d -prune

echo "Iniciando eliminación"
find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +

echo "############ Iniciando instalacion lambdas/josmejia2401-js ############"
echo "Entrando a josmejia2401-js"
cd "${BASEDIR}/lambdas/josmejia2401-js"
echo "Instanando en ${BASEDIR}/lambdas/josmejia2401-js"
npm install --production
echo "Regresando a $BASEDIR"
cd $BASEDIR

echo "############ Iniciando instalacion lambdas/core/celeste-cb ############"
echo "Entrando a josmejia2401-js"
cd "${BASEDIR}/lambdas/josmejia2401-js"
echo "Instanando en ${BASEDIR}/lambdas/core/celeste-cb"
pip3 install -r requirements.txt -t ./libs --no-deps
echo "Regresando a $BASEDIR"
cd $BASEDIR

echo "############ Iniciando instalacion lambdas/co~re/real-time ############"
echo "Entrando a josmejia2401-js"
cd "${BASEDIR}/lambdas/josmejia2401-js"
echo "Instanando en ${BASEDIR}/lambdas/core/real-time"
npm install --production
echo "Regresando a $BASEDIR"
cd $BASEDIR

echo "############ iac ##############"

echo "############ init ##############"
terraform init
echo "############ validate ##############"
terraform validate
echo "############ plan ##############"
terraform plan
echo "############ apply ##############"
terraform apply -auto-approve
echo "############ fin ##############"
