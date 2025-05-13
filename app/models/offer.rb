# == Schema Information
#
# Table name: offers
#
#  id                 :integer          not null, primary key
#  description        :text
#  listing_id         :integer
#  price              :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seller_id          :integer          not null
#  message_id         :integer
#  original_image_url :string
#
# Indexes
#
#  index_offers_on_seller_id  (seller_id)
#

class Offer < ApplicationRecord
  belongs_to :seller, class_name: "User"
  belongs_to :listing

  has_one_attached :image


  after_create :offer_message

  private

  def offer_message

    offer_url = Rails.application.routes.url_helpers.offer_url(self, host: 'muse-shopping.com')

    message = Message.new(
      listing: listing,
      sender: seller,
      recipient: listing.buyer,
      body: "You have a new offer: #{offer_url}"
    )

    message.save
  end
end
