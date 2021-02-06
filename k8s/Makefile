#TAG=$(shell git log -1 --pretty=format:%h)
TAG	  := latest
APP	  := flask-app

USER	:= xomodo
IMAGE	:= $(USER)/$(APP)

k8s-deploy:
	@kubectl create -f $(APP).yml --record --save-config

k8s-undeploy:
	@kubectl delete -f $(APP).yml

k8s-get-services:
	@kubectl get services

k8s-get-ingress:
	@kubectl get ingress

run: ## opens app with default browser
	minikube service $(APP)-api

IP	  = $(shell minikube ip)
PORT	= $(shell kubectl get svc $(APP)-api -o jsonpath="{.spec.ports[0].nodePort}"|xargs)

flask-app-status:
	@curl -s http://$(IP):$(PORT)/health | jq -c '.'

yamllint:
	@yamllint -d relaxed .
