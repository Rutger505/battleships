include .env

all: up

up: ssl
	docker compose up --watch --build --remove-orphans --force-recreate

up-%: ssl
	docker compose up --build --detach --remove-orphans --force-recreate $*

restart: up # start already rebuilds and recreates the containers

restart-%:
	make up-$*

down:
	docker compose down --remove-orphans

down-%:
	docker compose down --remove-orphans $*

shell-%:
	docker compose exec $* bash

ssl: ./ssl/localhost.pem

./ssl/%.pem:
	-mkdir ssl
	mkcert -install
	cd ssl && mkcert $*
	echo SSL certificates generated
