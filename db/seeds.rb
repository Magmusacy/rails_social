require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Destroy only these accounts
#TEST_ACCOUNTS = User.where(email: ["judy@alvarez.com", "panam@palmer.com", "jackie@welles.com"])
#TEST_ACCOUNTS.destroy_all
User.destroy_all


def generate_full_name_with_space
    full_name = ''

    loop do
        full_name = Faker::Movies::HarryPotter.unique.character
        break if full_name.include?(' ')
    end

    first_name, last_name = full_name.split(' ')
    [first_name, last_name]
end

USERS = [User.create(first_name: "Judy", last_name: "Alvarez", email: "judy@alvarez.com", password: "123456", password_confirmation: "123456"),
         User.create(first_name: "Panam", last_name: "Palmer", email: "panam@palmer.com", password: "654321", password_confirmation: "654321"),
         User.create(first_name: "Jackie", last_name: "Welles", email: "jackie@welles.com", password: "jackiewelles", password_confirmation: "jackiewelles")]

10.times do 
    first_name, last_name = generate_full_name_with_space
    USERS << User.create(first_name: first_name, last_name: last_name, email: Faker::Internet.email, password: "123456", password_confirmation: "123456")
end

# Create a random post for each user
USERS.each do |user|
    user.posts.create(body: Faker::Movies::HarryPotter.quote)
end

# Create a random comment for each post for each user
Post.all.each do |post|
    USERS.sample(5).each do |user|
        post.comments.create(body: Faker::Movies::HarryPotter.quote, author: user)
    end
end

