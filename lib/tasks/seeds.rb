categories = [
  "Electronics",
  "Fashion",
  "Accessories",
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
