# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  listing_id   :integer
#  recipient_id :integer
#  sender_id    :integer
#
class Message < ApplicationRecord
end
