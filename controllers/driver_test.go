package controllers

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"database/sql"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"

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

func TestRegisterDriver(t *testing.T) {
	r := gin.Default()
	r.POST("/drivers", RegisterDriver)

	jsonStr := []byte(`{
        "id": "1",
        "name": "Rodrigo",
        "username": "Serpentini",
        "password": "password",
        "is_on_trip": false
    }`)

	req, _ := http.NewRequest("POST", "/drivers", bytes.NewBuffer(jsonStr))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Driver registered successfully")
}
