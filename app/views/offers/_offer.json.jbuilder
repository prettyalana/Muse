json.extract! offer, :id, :seller_id, :image, :description, :listing_id, :price, :message_id, :created_at, :updated_at
json.url offer_url(offer, format: :json)
