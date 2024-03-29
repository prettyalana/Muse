# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  listing_id   :integer
#  recipient_id :integer          not null
#  sender_id    :integer          not null
#
# Indexes
#
#  index_messages_on_recipient_id  (recipient_id)
#  index_messages_on_sender_id     (sender_id)
#
# Foreign Keys
#
#  recipient_id  (recipient_id => users.id)
#  sender_id     (sender_id => users.id)
#
class Message < ApplicationRecord
  has_one :offer, class_name: "Offer"

  belongs_to :recipient, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :listing

  # scope :listing, -> { where(current_user: true)}

  validates :body, presence: true
end
