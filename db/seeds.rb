# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Destroy only these accounts
TEST_ACCOUNTS = User.where(email: ["judy@alvarez.com", "panam@palmer.com", "jackie@welles.com"])
TEST_ACCOUNTS.destroy_all

USERS = [User.create(first_name: "Judy", last_name: "Alvarez", email: "judy@alvarez.com", password: "123456", password_confirmation: "123456"),
         User.create(first_name: "Panam", last_name: "Palmer", email: "panam@palmer.com", password: "654321", password_confirmation: "654321"),
         User.create(first_name: "Jackie", last_name: "Welles", email: "jackie@welles.com", password: "jackiewelles", password_confirmation: "jackiewelles")]

# Create 3 random posts for each user
USERS.each do |user|
    user.posts.create(body: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.")
end