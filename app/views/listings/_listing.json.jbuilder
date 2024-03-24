json.extract! listing, :id, :image, :caption, :category_id, :buyer_id, :purchased, :created_at, :updated_at
json.url listing_url(listing, format: :json)
