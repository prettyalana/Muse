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
#  category_id :integer
#
# Indexes
#
#  index_listings_on_buyer_id  (buyer_id)
#
# Foreign Keys
#
#  buyer_id  (buyer_id => users.id)
#
class Listing < ApplicationRecord
  belongs_to :buyer, class_name: "User"
end
