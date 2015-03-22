class Role < ActiveRecord::Base
  default_scope { order('rank ASC') }

  def self.allowed(current_user_rank)
    Role.select { |r| r.rank <= current_user_rank }
  end

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :admin_users, :class_name => 'AdminUser'
end
