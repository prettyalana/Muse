# == Schema Information
#
# Table name: listings
#
#  id                 :bigint           not null, primary key
#  caption            :text
#  original_image_url :string
#  purchased          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  buyer_id           :bigint           not null
#  category_id        :bigint           not null
#
# Indexes
#
#  index_listings_on_buyer_id     (buyer_id)
#  index_listings_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (buyer_id => users.id)
#  fk_rails_...  (category_id => categories.id)
#
class Listing < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :category, class_name: "Category"

  has_many :messages, class_name: "Message"
  has_many :offers, class_name: "Offer"

  has_many_attached :images

  validates :caption, presence: true

  scope :purchased_listings, -> { where(purchased: true) }

  scope :listing, -> { where(current_user: true)}
end
