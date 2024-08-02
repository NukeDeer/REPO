package main

import (
	"REPO/ChallengerAPI/middleware"
	"REPO/controllers"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.POST("/login", controllers.Login)

	admin := r.Group("/admin")
	admin.Use(middleware.AuthMiddleware("admin"))
	{
		admin.GET("/drivers", controllers.GetDrivers)
	}

	driver := r.Group("/driver")
	driver.Use(middleware.AuthMiddleware("driver"))
	{
		driver.GET("/profile", controllers.GetDriverProfile)
	}

	r.Run()
}
