# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
categories = [
  "Fashion",
  "Accessories",
  "Jewelry",
  "Electronics",
  "Home & Garden",
  "Health & Beauty",
  "Toys & Games",
  "Sports & Outdoors",
  "Books & Media",
  "Pet Supplies",
  "Automotive"
]

categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

p "Created #{Category.count} categories."
