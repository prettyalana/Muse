# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  listing_id   :integer
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#
# Indexes
#
#  index_messages_on_recipient_id  (recipient_id)
#  index_messages_on_sender_id     (sender_id)
#

class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  belongs_to :listing

  has_one_attached :image

  validates :body, presence: true
end
