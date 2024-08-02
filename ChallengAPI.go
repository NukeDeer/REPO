package main

import (
	"REPO/controllers"
	"REPO/middleware"
	"REPO/models"
	"log"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var db *gorm.DB

func setupDatabase() {
	var err error
	dsn := "sa:Mondongo@tcp(127.0.0.1:1433)/ChallengeAPI?charset=utf8mb4&parseTime=True&loc=Local"
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Error connecting to database: %v", err)
	}

	err = runMigrationScript()
	if err != nil {
		log.Fatalf("Error running migration script: %v", err)
	}

	db.AutoMigrate(&models.Driver{})

	controllers.SetDatabase(db)
}

func runMigrationScript() error {
	script, err := os.ReadFile("ChallengeAPI.sql")
	if err != nil {
		return err
	}
	return db.Exec(string(script)).Error
}

func main() {
	setupDatabase()

	r := gin.Default()

	r.Use(cors.Default())

	r.POST("/login", controllers.Login)

	admin := r.Group("/admin")
	admin.Use(middleware.AuthMiddleware("admin"))
	{
		admin.GET("/drivers", controllers.GetDrivers)
		admin.POST("/drivers", controllers.RegisterDriver)
	}

	driver := r.Group("/driver")
	driver.Use(middleware.AuthMiddleware("driver"))
	{
		driver.GET("/profile", controllers.GetDriverProfile)
	}

	available := r.Group("/available")
	available.Use(middleware.AuthMiddleware(""))
	{
		available.GET("/drivers", controllers.GetAvailableDrivers)
	}

	r.Run()
}
