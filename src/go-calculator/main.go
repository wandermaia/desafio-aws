package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/v5"
	_ "github.com/go-sql-driver/mysql"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

type Request struct {
	Nome      string `json:"nome"`
	Operador1 int    `json:"operador1"`
	Operador2 int    `json:"operador2"`
}

type Response struct {
	Resultado int `json:"resultado"`
}

var db *sql.DB

// Definição da métrica de número de reuquisições para o prometheus. Disponibiliza para o prometheus a quantidade total de operações GET realizadas.
var (
	totalGets = promauto.NewCounter(prometheus.CounterOpts{
		Name: "go_calculator_total_gets",
		Help: "Numero total de GETs processados",
	})
)

// Definição da métrica de número de reuquisições para o prometheus. Disponibiliza para o prometheus a quantidade total de operações POST realizadas.
var (
	totalPost = promauto.NewCounter(prometheus.CounterOpts{
		Name: "go_calculator_total_posts",
		Help: "Numero total de POSTs processados",
	})
)

// Definição da métrica de número de reuquisições para o prometheus. Disponibiliza para o prometheus a quantidade total de erros.
var (
	totalErros = promauto.NewCounter(prometheus.CounterOpts{
		Name: "go_calculator_total_errors",
		Help: "Numero total de POSTs processados",
	})
)

// Função de inicalização do banco de dados.
func initDB() {
	dsn := fmt.Sprintf("%s:%s@tcp(%s)/%s",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_HOST"),
		os.Getenv("DB_NAME"),
	)

	var err error
	db, err = sql.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("Erro ao conectar ao banco de dados: %v", err)
	}

	log.Println("Banco de dados conectado com sucesso")

	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS operacoes (
		id INT AUTO_INCREMENT PRIMARY KEY,
		nome VARCHAR(255) NOT NULL,
		operador1 INT NOT NULL,
		operador2 INT NOT NULL,
		data_execucao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	)`)
	if err != nil {
		log.Fatalf("Erro ao criar tabela: %v", err)
	}

	log.Println("Tabela operacoes verificada/criada com sucesso")
}

// Função para a execução da chamada GET. Foi criada apenas para validação simples.
func getHandler(w http.ResponseWriter, r *http.Request) {
	totalGets.Inc()
	log.Println("Requisição GET recebida em /backend")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("API em execução!"))
}

// Função para a execução da chamada POST
func postHandler(w http.ResponseWriter, r *http.Request) {
	totalPost.Inc()
	log.Println("Requisição POST recebida em /backend")
	var req Request
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&req); err != nil {
		totalErros.Inc()
		log.Printf("Erro ao decodificar JSON: %v", err)
		http.Error(w, "Erro ao processar dados para soma. São aceitos apenas números inteiros.", http.StatusBadRequest)
		return
	}

	if len(req.Nome) < 3 {
		totalErros.Inc()
		log.Println("Nome inválido recebido!")
		http.Error(w, "Nome deve ter pelo menos 3 caracteres", http.StatusBadRequest)
		return
	}

	resultado := req.Operador1 + req.Operador2
	log.Printf("Operação realizada: %d + %d = %d", req.Operador1, req.Operador2, resultado)

	_, err := db.Exec("INSERT INTO operacoes (nome, operador1, operador2, data_execucao) VALUES (?, ?, ?, ?)",
		req.Nome, req.Operador1, req.Operador2, time.Now())
	if err != nil {
		log.Printf("Erro ao inserir no banco de dados: %v", err)
		http.Error(w, "Erro ao inserir no banco de dados: ", http.StatusInternalServerError)
		return
	}

	log.Println("Operação registrada no banco de dados com sucesso")
	json.NewEncoder(w).Encode(Response{Resultado: resultado})
}

func main() {
	log.Println("Iniciando a API ...")
	initDB()
	defer db.Close()

	r := chi.NewRouter()
	r.Get("/backend", getHandler)
	r.Post("/backend", postHandler)
	r.Handle("/metrics", promhttp.Handler())

	log.Println("Servidor rodando na porta 7000 ...")
	log.Fatal(http.ListenAndServe(":7000", r))
}
