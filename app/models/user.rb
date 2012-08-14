class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :email, :password, :password_confirmation, :remember_me, :organization_ids
  # attr_accessible :title, :body

  has_and_belongs_to_many :organizations, :uniq => true

end
