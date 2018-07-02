.PHONY: deploy backend db

default: rm db back

deploy:
	docker-compose up -d

back:
	docker run -p 8000:8000 --env-file env/jorgechato.com/${ENV}.env -v ${PWD}/trol:/code/static --restart on-failure --name backend -d backend

db:
	docker run -p 5432:5432 --env-file env/jorgechato.com/${ENV}.env -v ${PWD}/dbdata:/var/lib/postgresql/data --restart on-failure --name database -d postgres:alpine

rm: rmb rmd rmn

rmb:
	docker rm -f backend

rmd:
	docker rm -f database

rmn:
	docker rm -f nginx

clean: $(rm) $(rmi)
	rm -rf out dbdata static logs

collect:
	python manage.py collectstatic

pull:
	docker pull quay.io/orggue/jorgechato

build: rmi
	docker build -t backend .
	docker tag backend quay.io/orggue/jorgechato

rmi:
	docker rmi -f backend
	docker rmi -f quay.io/orggue/jorgechato
