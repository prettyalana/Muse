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
#  seller_id   :integer          not null
#
# Indexes
#
#  index_offers_on_seller_id  (seller_id)
#
# Foreign Keys
#
#  seller_id  (seller_id => users.id)
#
class Offer < ApplicationRecord
  belongs_to :seller, class_name: "User"
  belongs_to :listing

  after_create :offer_message

  private

  def offer_message

    offer_url = Rails.application.routes.url_helpers.offer_url(self)

    message = Message.new(
      listing: listing,
      sender: seller,
      recipient: listing.buyer,
      body: "You have a new offer: #{offer_url}"
    )

    message.save
  end
end
