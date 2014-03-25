class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :active, -> { where(inactive: false) }
  scope :inactive, -> { where(inactive: true) }
  default_scope { order('name ASC') }

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :phone, :email, :password, :password_confirmation, :remember_me, :category, :course

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

  def can_deactivate?
    not admin? and not inactive
  end

  # For preventing users from hard deleting their accounts  
  def soft_delete
    update_attribute(:inactive, true)
  end
  
  def activate
    update_attribute(:inactive, false)
  end

  # Not allowing "inactive" users to sign in
  def active_for_authentication?
    super && !inactive
  end
end
