class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :course, :email, :name, :phone, :type

  has_many :reservations
  has_many :items, :through => :reservations

  validates :name, :presence => true

  #user types
  ADMIN = 0
  FACULTY = 1
  BASIC = 2
end
