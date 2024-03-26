# == Schema Information
#
# Table name: listings
#
#  id          :integer          not null, primary key
#  caption     :text
#  image       :string
#  purchased   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  buyer_id    :integer          not null
#  category_id :integer          not null
#
# Indexes
#
#  index_listings_on_buyer_id     (buyer_id)
#  index_listings_on_category_id  (category_id)
#
# Foreign Keys
#
#  buyer_id     (buyer_id => users.id)
#  category_id  (category_id => categories.id)
#
class Listing < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :category, class_name: "Category"
  
  has_many :messages, class_name: "Message"
  has_many :offers, through: :messages
  
  
  validates :caption, presence: true
  validates :image, presence: true

  enum purchased: { purchased: "purchased", not_purchased: "not_purchased" }
end
