package db

import (
	"database/sql"

	_ "github.com/denisenkom/go-mssqldb"
)

var DB *sql.DB

func InitDB() {
	DB, err := sql.Open("mysql", "Challenger.db")
	if err != nil {
		panic("No hay conexion a la Base de datos")
	}

	DB.SetMaxOpenConns(10)
	DB.SetMaxIdleConns(5)
}
