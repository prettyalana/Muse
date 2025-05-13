# == Schema Information
#
# Table name: listings
#
#  id                 :integer          not null, primary key
#  caption            :text
#  purchased          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  buyer_id           :integer          not null
#  category_id        :integer          not null
#  original_image_url :string
#
# Indexes
#
#  index_listings_on_buyer_id     (buyer_id)
#  index_listings_on_category_id  (category_id)
#

class Listing < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :category, class_name: "Category"

  has_many :messages, class_name: "Message"
  has_many :offers, class_name: "Offer"

  has_one_attached :image

  validates :caption, presence: true

  scope :purchased_listings, -> { where(purchased: true) }

  scope :listing, -> { where(current_user: true)}
end
