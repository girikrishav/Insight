class Holiday < ActiveRecord::Base
  validates :name, presence: :true
  validates :as_on, presence: :true
  validates :business_units, presence: :true

  validates_uniqueness_of :name, scope: [:name, :as_on, :business_unit_id]

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :business_unit_id
end
