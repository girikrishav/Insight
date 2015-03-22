class CostAdderType < ActiveRecord::Base
  default_scope { order('rank ASC') }

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :overheads, :class_name => 'Overhead'
end
