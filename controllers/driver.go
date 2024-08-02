package controllers

import (
	"net/http"
	"strconv"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type Driver struct {
	ID       string `json:"id"`
	Name     string `json:"name"`
	Username string `json:"username"`
	Password string `json:"password"`
	IsOnTrip bool   `json:"is_on_trip"`
}

var db *gorm.DB

func RegisterDriver(c *gin.Context) {
	var newDriver Driver
	if err := c.BindJSON(&newDriver); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	if err := db.Create(&newDriver).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not register driver"})
		return
	}

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

	var drivers []Driver
	result := db.Offset(start).Limit(size).Find(&drivers)
	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error fetching drivers"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"drivers": drivers})
}

func GetAvailableDrivers(c *gin.Context) {
	var availableDrivers []Driver
	result := db.Where("is_on_trip = ?", false).Find(&availableDrivers)
	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error fetching available drivers"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"drivers": availableDrivers})
}

func GetDriverProfile(c *gin.Context) {
	userId := c.MustGet("user_id").(string)
	var driver Driver
	result := db.First(&driver, "id = ?", userId)
	if result.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Driver not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"profile": driver})
}
