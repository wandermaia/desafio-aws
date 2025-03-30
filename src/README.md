
curl -X POST http://localhost:36175/backend -H "Content-Type: application/json" -d '{"nome":"João", "operador1":5, "operador2":10}'

curl http://calculadora-api.calculator.svc.cluster.local/backend
curl -X POST http://calculadora-api.calculator.svc.cluster.local/backend -H "Content-Type: application/json" -d '{"nome":"João", "operador1":5, "operador2":10}'


curl http://internal-k8s-calculat-ingressa-1f96086ccc-1451221242.us-east-1.elb.amazonaws.com/backend

curl -X POST http://internal-k8s-calculat-ingressa-1f96086ccc-1451221242.us-east-1.elb.amazonaws.com/backend -H "Content-Type: application/json" -d '{"nome":"João", "operador1":5, "operador2":10}'