class Designation < ActiveRecord::Base
  default_scope { order('rank ASC') }

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :staffing_requirements, :class_name => 'StaffingRequirement'
  has_many :service_rates, :class_name => 'ServiceRate'
  has_many :assignments, :class_name => 'Assignment'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
  has_many :assignment_allocations, :class_name => 'AssignmentAllocation'
end
