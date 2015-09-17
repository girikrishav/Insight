class VacationReason < ActiveRecord::Base
  validates :name, presence: :true
  validates :paid, presence: :true
  validates :days_allowed, presence: :true
  validates :business_unit_id, presence: :true

  validates_uniqueness_of :name, scope: [:name, :business_unit_id]

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :business_unit_id
  belongs_to :paid, :class_name => 'FlagStatus', :foreign_key => :is_paid
end
