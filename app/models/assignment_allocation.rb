class AssignmentAllocation < ActiveRecord::Base
  def start_end_date_check
    if self.start_date > self.end_date
      errors.add(:start_date, I18n.t('errors.start_after_end_date'))
      errors.add(:end_date, I18n.t('errors.end_before_start_date'))
    end
  end

  def hours_check
    if self.hours_per_day <= 0 or self.hours_per_day > 24
      errors.add(:hours_per_day, I18n.t('errors.hours_violation'))
    end
  end

  def self.associate_allocated_hours(associate_id, assignment_id, as_on)
    allocated_hours = 0
    AssignmentAllocation.where(associate_id: associate_id).each do |aa|
      if aa.assignment.id != assignment_id and as_on >= aa.start_date and as_on <= aa.end_date
        allocated_hours += aa.hours_per_day
      end
    end
    allocated_hours
  end

  validates :project, presence: :true
  validates :skill, presence: :true
  validates :designation, presence: :true
  validates :associate, presence: :true
  validates :start_date, presence: :true
  validates :end_date, presence: :true
  validates :hours_per_day, presence: :true
  validates :assignment_id, presence: :true, uniqueness: :true

  validate :start_end_date_check
  validate :hours_check

  belongs_to :skill, :class_name => 'Skill', :foreign_key => :skill_id
  belongs_to :assignment, :class_name => 'Assignment', :foreign_key => :assignment_id
  belongs_to :associate, :class_name => 'Associate', :foreign_key => :associate_id
  belongs_to :designation, :class_name => 'Designation', :foreign_key => :designation_id
  belongs_to :project, :class_name => 'Project', :foreign_key => :project_id
end
