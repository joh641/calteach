class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :course, :email, :name, :phone, :category

  has_many :reservations
  has_many :items, :through => :reservations

  validates :name, :presence => true

  # constants defining user types
  ADMIN = 0
  FACULTY = 1
  BASIC = 2

  def category_str
    if category == ADMIN
      "Admin"
    elsif category == FACULTY
      "Faculty"
    else
      "Basic"
    end
  end

  def admin?
    return category == ADMIN
  end
end
