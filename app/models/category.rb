# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           default("clothing")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :listings, class_name: "Listing", foreign_key: "category_id", dependent: :destroy
  validates :name, uniqueness: true
  #This is if I only want three categories
  # enum :name, {clothing: "clothing", shoes: "shoes", accessories: "accessories"}
end
