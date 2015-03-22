class FlagStatus < ActiveRecord::Base
  default_scope { order('rank ASC') }

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :vacation_reasons, :class_name => 'VacationReason'
  has_many :staffing_requirements, :class_name => 'StaffingRequirement'
  has_many :project_types, :class_name => 'ProjectType'
  has_many :associates, :class_name => 'Associate'
  has_many :associate_histories, :class_name => 'AssociateHistory'
  has_many :assignments, :class_name => 'Assignment'
  has_many :assignments, :class_name => 'Assignment'
  has_many :assignments, :class_name => 'Assignment'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
end
