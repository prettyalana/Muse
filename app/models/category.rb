# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           default("clothing")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :listings, class_name: "Listing", foreign_key: "category_id", dependent: :destroy
  validates :name, uniqueness: true
end
