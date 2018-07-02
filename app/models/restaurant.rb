class Restaurant < ApplicationRecord
  validates_presence_of :name, :category

  mount_uploader :image, PhotoUploader

  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_user, through: :favorites, source: :user

  def is_favorited?(user)
    self.favorited_user.include?(user)
  end
end
