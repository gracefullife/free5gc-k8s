#!/bin/bash

CLUSTER_NAME=f5gc
set -xo pipefail
if [ -z "$(which kind)" ];then
  echo please install kind at first
  echo https://kind.sigs.k8s.io/
fi
if [ -z "$(kind get clusters | grep ${CLUSTER_NAME})" ];then
  kind create cluster --name ${CLUSTER_NAME} --config clusters/kind/config.yaml
fi


kubectl apply -f ./clusters/kind/kata-deploy/kata-deploy/base/kata-deploy.yaml
kubectl apply -f ./clusters/kind/kata-deploy/kata-rbac/base/kata-rbac.yaml
kubectl apply -f ./clusters/kind/kata-deploy/k8s-1.18/kata-runtimeClasses.yaml

kubectl wait --for=condition=ready -n kube-system daemonset -l name=kata-deploy

kubectl apply -f manifests/components/00_namespace.yaml
kubens f5gc
kustomize build manifests/environments/kind | kubectl apply -f -
