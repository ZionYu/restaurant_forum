class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  validates_presence_of :name
  mount_uploader :avatar, AvatarUploader
  has_many :comments, dependent: :restrict_with_error
  has_many :restaurants, through: :comments

  has_many :favorites, dependent: :destroy
  has_many :favorited_restaurants, through: :favorites, source: :restaurant

  has_many :likes, dependent: :destroy
  has_many :liked_restaurants, through: :likes, source: :restaurant

  has_many :followships, dependent: :destroy
  has_many :followings, through: :followships 

  has_many :inverse_followships, class_name: "Followship", foreign_key: "following_id"
  has_many :followers, through: :inverse_followships, source: :user

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: "friend_id"
  has_many :passive_friends, through: :inverse_friendships, source: :user

  def admin?
    self.role == "admin"
    
  end

  def following?(user)
   self.followings.include?(user) 
  end

  def friends?(user)
    self.friends.include?(user)
  end

  def all_friends
    (friends + passive_friends).uniq
  end
  
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:google_token => access_token.credentials.token, :google_uid => access_token.uid ).first    
    if user
      return user
    else
      existing_user = User.where(:email => data["email"]).first
      if  existing_user
        existing_user.google_uid = access_token.uid
        existing_user.google_token = access_token.credentials.token
        existing_user.save!
        return existing_user
      else
    # Uncomment the section below if you want users to be created if they don't exist
        user = User.create(name: data["name"],
            email: data["email"],
            password: Devise.friendly_token[0,20],
            avatar: data["image"],
            gender: access_token.extra.raw_info.gender,
            google_token: access_token.credentials.token,
            google_uid: access_token.uid
        )
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:google_token => access_token.credentials.token, :google_uid => access_token.uid ).first    
    if user
      return user
    else
      existing_user = User.where(:email => data["email"]).first
      if  existing_user
        existing_user.google_uid = access_token.uid
        existing_user.google_token = access_token.credentials.token
        existing_user.save!
        return existing_user
      else
    # Uncomment the section below if you want users to be created if they don't exist
        user = User.create(
            name: data["name"],
            email: data["email"],
            password: Devise.friendly_token[0,20],
            google_token: access_token.credentials.token,
            google_uid: access_token.uid
          )
      end
    end
  end


  
end
 