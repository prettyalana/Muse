json.extract! message, :id, :sender_id, :recipient_id, :listing_id, :body, :created_at, :updated_at
json.url message_url(message, format: :json)
