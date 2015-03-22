class Department < ActiveRecord::Base
  default_scope { order('rank ASC') }

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :associates, :class_name => 'Associate'
  has_many :associate_histories, :class_name => 'AssociateHistory'
end
