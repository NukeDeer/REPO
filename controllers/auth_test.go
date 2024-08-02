package controllers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestDriverLoginFailed(t *testing.T) {
	// Configurar Gin en modo de prueba
	gin.SetMode(gin.TestMode)

	// Crear un router de Gin
	router := gin.Default()

	// Registrar la ruta de login
	router.POST("/login", Login)

	// Crear una petición de prueba con credenciales incorrectas
	loginCredentials := map[string]string{
		"username": "wrongUsername",
		"password": "wrongPassword",
	}
	jsonValue, _ := json.Marshal(loginCredentials)
	req, _ := http.NewRequest(http.MethodPost, "/login", bytes.NewBuffer(jsonValue))
	req.Header.Set("Content-Type", "application/json")

	// Crear un ResponseRecorder para registrar la respuesta
	rr := httptest.NewRecorder()

	// Ejecutar la petición
	router.ServeHTTP(rr, req)

	// Verificar que la respuesta sea 401 Unauthorized
	assert.Equal(t, http.StatusUnauthorized, rr.Code)
}
