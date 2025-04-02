
curl -X POST http://localhost:36175/backend -H "Content-Type: application/json" -d '{"nome":"João", "operador1":5, "operador2":10}'

curl http://calculadora-api.calculator.svc.cluster.local/backend
curl -X POST http://calculadora-api.calculator.svc.cluster.local/backend -H "Content-Type: application/json" -d '{"nome":"João", "operador1":5, "operador2":10}'


curl http://internal-k8s-calculat-ingressa-1f96086ccc-1451221242.us-east-1.elb.amazonaws.com/backend

curl -X POST http://internal-k8s-calculat-ingressa-1f96086ccc-1451221242.us-east-1.elb.amazonaws.com/backend -H "Content-Type: application/json" -d '{"nome":"João", "operador1":5, "operador2":10}'


sudo apt update
sudo apt install mysql-client -y
mysql -h rds-msql-dev.cilkaqg0kfik.us-east-1.rds.amazonaws.com -P 3306 -udbuser -pdbpassword -D mydb

mysql -h mysql-dev.wandermaia.com -P 3306 -udbuser -pdbpassword -D mydb

aws eks --region us-east-1 update-kubeconfig --name eks-dev


sudo apt update
sudo apt install apache2
sudo systemctl status apache2

apt install dnsutils

docker exec -it mysql-8 /bin/bash
mysql -h localhost -P 3306 -uuser -ppassword -D go-calculator

curl http://localhost:7000/backend -i

curl -X POST http://localhost:7000/backend -H "Content-Type: application/json" -d '{"nome":"Wander", "operador1":5, "operador2":10}'


docker stop $(docker ps -a -q)

docker rm $(docker ps -a -q)

docker image prune -a
docker system prune --volumes