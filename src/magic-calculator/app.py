from flask import Flask, render_template, request, jsonify, redirect, url_for
import requests
import os

# --- INÍCIO INSTRUMENTAÇÃO OPENTELEMETRY ---
from opentelemetry import trace
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor

# Configura o nome do serviço (aparecerá no SigNoz)
resource = Resource.create({"service.name": "magic-calculator"})

# Configura o Provider e o Exportador para o ADOT Collector
provider = TracerProvider(resource=resource)
# O endpoint aponta para o seu coletor no namespace signoz
exporter = OTLPSpanExporter(endpoint="http://adot-collector-collector.signoz.svc.cluster.local:4317", insecure=True)
processor = BatchSpanProcessor(exporter)
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

# Ativa a instrumentação automática para Flask e Requests
# Isso vai capturar as rotas e as chamadas externas para a API_URL
RequestsInstrumentor().instrument()
# --- FIM INSTRUMENTAÇÃO OPENTELEMETRY ---

app = Flask(__name__)

API_URL = os.environ.get('API_URL', 'http://localhost:7000/backend')  # Obtém a URL da API da variável de ambiente

@app.route('/frontend', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        nome = request.form['nome']
        operador1 = request.form['operador1']
        operador2 = request.form['operador2']

        # Validação dos dados
        if len(nome) < 3:
            return render_template('index.html', error='Nome deve ter pelo menos 3 caracteres.')
        try:
            operador1 = int(operador1)
            operador2 = int(operador2)
        except ValueError:
            return render_template('index.html', error='Operadores devem ser números inteiros.')

        data = {'nome': nome, 'operador1': operador1, 'operador2': operador2}
        headers = {'Content-Type': 'application/json'}

        try:
            response = requests.post(API_URL, json=data, headers=headers)
            response.raise_for_status()  # Lança exceção para status HTTP de erro .
            result = response.json().get('resultado')
            return render_template('result.html', result=result)
        except requests.exceptions.RequestException as e:
            return render_template('error.html', error=str(e))
    return render_template('index.html')

@app.route('/frontend/voltar')
def voltar():
  return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0')
    #app.run(debug=True, host='0.0.0.0')
