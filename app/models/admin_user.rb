class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  default_scope {order('email ASC')}

  def self.allowed_ids(current_user_rank, current_user_id)
    allowed = Array[]
    AdminUser.all.each do |au|
      if au.allowed_check(current_user_rank, current_user_id  )
        allowed.push(au.id)
      end
    end
    allowed
  end

  def self.allowed(current_user_rank, current_user_id)
    AdminUser.select {|au| au.allowed_check(current_user_rank, current_user_id) }
  end

  def allowed_check(current_user_rank, current_user_id)
    if Role.find(self.role_id).rank < current_user_rank or self.id == current_user_id
      return true
    end
    return false
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: :true, format: { with: VALID_EMAIL_REGEX }, uniqueness: :true
  validates :password, presence: :true
  validates :password_confirmation, presence: :true
  validates :role, presence: :true
  validates :active, presence: :true

  has_many :associates, :class_name => 'Associate'
  has_many :associate_histories, :class_name => 'AssociateHistory'
  belongs_to :role, :class_name => 'Role', :foreign_key => :role_id
  belongs_to :active, :class_name => 'UserStatus', :foreign_key => :is_active
end
