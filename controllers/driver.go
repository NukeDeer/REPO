package controllers

import (
	"net/http"
	"strconv"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

type Driver struct {
	ID       string `json:"id"`
	Name     string `json:"name"`
	Username string `json:"username"`
	Password string `json:"password"`
	IsOnTrip bool   `json:"is_on_trip"`
}

var jwtKey = []byte("my_secret_key")

type Credentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type Claims struct {
	Username string `json:"username"`
	Role     string `json:"role"`
	jwt.StandardClaims
}

var drivers = []Driver{}

func RegisterDriver(c *gin.Context) {
	var newDriver Driver
	if err := c.BindJSON(&newDriver); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	drivers = append(drivers, newDriver)

	expirationTime := time.Now().Add(5 * time.Minute)
	claims := &Claims{
		Username: newDriver.Username,
		Role:     "driver",
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Driver registered successfully",
		"token":   tokenString,
	})
}

func GetDriversWithPagination(c *gin.Context) {
	pageStr := c.DefaultQuery("page", "1")
	sizeStr := c.DefaultQuery("size", "10")

	page, err := strconv.Atoi(pageStr)
	if err != nil || page < 1 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid page number"})
		return
	}

	size, err := strconv.Atoi(sizeStr)
	if err != nil || size < 1 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid page size"})
		return
	}

	start := (page - 1) * size
	end := start + size

	if start >= len(drivers) {
		c.JSON(http.StatusOK, gin.H{"drivers": []Driver{}})
		return
	}

	if end > len(drivers) {
		end = len(drivers)
	}

	paginatedDrivers := drivers[start:end]
	c.JSON(http.StatusOK, gin.H{"drivers": paginatedDrivers})
}

func GetAvailableDrivers(c *gin.Context) {
	availableDrivers := []Driver{}
	for _, driver := range drivers {
		if !driver.IsOnTrip {
			availableDrivers = append(availableDrivers, driver)
		}
	}
	c.JSON(http.StatusOK, gin.H{"drivers": availableDrivers})
}

func GetDriverProfile(c *gin.Context) {
	userId := c.MustGet("user_id").(string)
	profile := map[string]string{"user_id": userId, "name": "John Doe", "status": "Active"}
	c.JSON(http.StatusOK, gin.H{"profile": profile})
}
func Login(c *gin.Context) {
	var creds Credentials
	if err := c.BindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	var role string
	if creds.Username == "admin" && creds.Password == "password" {
		role = "admin"
	} else if creds.Username == "driver" && creds.Password == "password" {
		role = "driver"
	} else {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	expirationTime := time.Now().Add(5 * time.Minute)
	claims := &Claims{
		Username: creds.Username,
		Role:     role,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": tokenString})
}
