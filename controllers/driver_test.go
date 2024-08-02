package controllers

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var testDB *gorm.DB

func setupTestDatabase() {
	var err error
	dsn := "username:password@tcp(127.0.0.1:3306)/testdb?charset=utf8mb4&parseTime=True&loc=Local"
	testDB, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("Failed to connect to test database")
	}

	testDB.Exec("DROP TABLE IF EXISTS drivers")
	testDB.Exec("CREATE TABLE drivers (id VARCHAR(255) PRIMARY KEY, name VARCHAR(255), username VARCHAR(255) UNIQUE, password VARCHAR(255), is_on_trip BOOLEAN)")
}

func TestRegisterDriver(t *testing.T) {
	setupTestDatabase()

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
