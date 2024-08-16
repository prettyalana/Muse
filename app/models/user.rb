# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  account_type           :string           default("buyer")
#  address                :string
#  bio                    :text
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  location               :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :citext
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, class_name: "Listing", foreign_key: :buyer_id
  has_many :purchased_listings, -> { where(purchased: "purchased")}, foreign_key: :buyer_id, class_name: "Listing"

  has_many :sent_offers, foreign_key: :seller_id, class_name: "Offer", dependent: :destroy
  has_many :accepted_counter_offers, -> { where(status: "accepted") }, foreign_key: :sender_id, class_name: "Offer"

  has_many :sent_messages, foreign_key: :sender_id, class_name: "Message", dependent: :destroy
  has_many :replied_messages, foreign_key: :recipient_id, class_name: "Message"

  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true

  enum :account_type, { buyer: "buyer", seller: "seller" }
end
