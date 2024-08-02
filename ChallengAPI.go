package main

import (
	"REPO/ChallengerAPI/middleware"
	"REPO/controllers"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	r.POST("/login", controllers.Login)

	admin := r.Group("/admin")
	admin.Use(middleware.AuthMiddleware("admin"))
	{
		admin.GET("/drivers", controllers.GetDriversWithPagination)
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
