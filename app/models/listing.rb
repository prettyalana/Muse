# == Schema Information
#
# Table name: listings
#
#  id          :integer          not null, primary key
#  caption     :text
#  image       :string
#  purchased   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  buyer_id    :integer
#  category_id :integer
#
class Listing < ApplicationRecord
end
