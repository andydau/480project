class User < ActiveRecord::Base

  has_many :problems
  has_many :attempts
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  validates :name, :email, presence: true
  validates :name, :email, uniqueness: true

  def self.create_with_omniauth(auth)
    @user = nil
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
        #user.avatar = auth['info']['image']
      end
      @user = user
    end
    return @user
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name # assuming the user model has a name
      user.password = Devise.friendly_token[0,20]
    end
  end

end
