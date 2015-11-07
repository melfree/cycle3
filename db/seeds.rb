# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


User.create!(email: "test@gmail.com", name: "Test User", password: "password", password_confirmation: "password")
User.create!(email: "test@aol.com", name: "Test User", password: "password", password_confirmation: "password")
User.create!(email: "testuser@gmail.com", name: "Test User", password: "password", password_confirmation: "password")
User.create!(email: "testuser@aol.com", name: "Test User", password: "password", password_confirmation: "password")