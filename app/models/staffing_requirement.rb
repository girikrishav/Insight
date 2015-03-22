class StaffingRequirement < ActiveRecord::Base
  def start_end_date_check
    if self.start_date > self.end_date
      errors.add(:start_date, I18n.t('errors.start_after_end_date'))
      errors.add(:end_date, I18n.t('errors.end_before_start_date'))
    end
  end

  def hours_check
    if self.hours_per_day <= 0 or self.hours_per_day > 24
      errors.add(:hours_per_day, I18n.t('errors.hours_check'))
    end
  end

  def number_required_check
    if self.number_required <= 0
      errors.add(:number_required, I18n.t('errors.number_required_check'))
    end
  end

  def project_dates_check
    @project = Project.find(self.project_id)
    if self.start_date < @project.start_date or self.end_date > @project.end_date
      errors.add(:start_date, I18n.t('errors.project_dates_violation'\
          , project_start_date: @project.start_date, project_end_date: @project.end_date))
      errors.add(:end_date, I18n.t('errors.project_dates_violation'\
          , project_start_date: @project.start_date, project_end_date: @project.end_date))
    end
  end

  validates :designation, presence: :true
  validates :end_date, presence: :true
  validates :hours_per_day, presence: :true
  validates :fulfilled, presence: :true
  validates :number_required, presence: :true
  validates :skill, presence: :true
  validates :start_date, presence: :true
  validates :project, presence: :true

  validate :start_end_date_check
  validate :hours_check
  validate :number_required_check
  validate :project_dates_check

  belongs_to :fulfilled, :class_name => 'FlagStatus', :foreign_key => :is_fulfilled
  belongs_to :skill, :class_name => 'Skill', :foreign_key => :skill_id
  belongs_to :designation, :class_name => 'Designation', :foreign_key => :designation_id
  belongs_to :project, :class_name => 'Project', :foreign_key => :project_id
end
