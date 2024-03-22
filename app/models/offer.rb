# == Schema Information
#
# Table name: offers
#
#  id          :integer          not null, primary key
#  description :text
#  image       :string
#  price       :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  listing_id  :integer
#  message_id  :integer
#  seller_id   :integer
#
class Offer < ApplicationRecord
end
