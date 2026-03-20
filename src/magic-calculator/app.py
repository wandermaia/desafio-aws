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
FlaskInstrumentor().instrument_app(app) # Instrumenta o app Flask

API_URL = os.environ.get('API_URL', 'http://localhost:7000/backend')

@app.route('/frontend', methods=['GET', 'POST'])
def index():
    # ... seu código original ...
    if request.method == 'POST':
        # ... logic ...
        try:
            # O RequestsInstrumentor vai capturar este POST automaticamente
            response = requests.post(API_URL, json=data, headers=headers)
            # ... rest of logic ...
            return render_template('result.html', result=result)
        except requests.exceptions.RequestException as e:
            return render_template('error.html', error=str(e))
    return render_template('index.html')

@app.route('/frontend/voltar')
def voltar():
  return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
