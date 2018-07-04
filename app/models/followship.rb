class Followship < ApplicationRecord
  validates :following_id, uniqness: { scope: :user_id}

  belongs_to :user
  belongs_to :following, class_name: "user"
end
