package models

import "gorm.io/gorm"

type Driver struct {
	gorm.Model
	ID       string `json:"id"`
	Name     string `json:"name"`
	Username string `json:"username"`
	Password string `json:"password"`
	IsOnTrip bool   `json:"is_on_trip"`
}
