class Currency < ActiveRecord::Base
  default_scope { order('name ASC') }

  validates :name, presence: :true, uniqueness: :true

  has_many :business_units, :class_name => 'BusinessUnit'
end
