from flask import Flask, render_template, request, jsonify, redirect, url_for
import requests
import os

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
            response.raise_for_status()  # Lança exceção para status HTTP de erro
            result = response.json().get('resultado')
            return render_template('result.html', result=result)
        except requests.exceptions.RequestException as e:
            return render_template('error.html', error=str(e))
    return render_template('index.html')

@app.route('/voltar')
def voltar():
  return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
