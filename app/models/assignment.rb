class Assignment < ActiveRecord::Base
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

  def project_dates_check
    @project = Project.find(self.project_id)
    if self.start_date < @project.start_date or self.end_date > @project.end_date
      errors.add(:start_date, I18n.t('errors.project_dates_violation'\
          , project_start_date: @project.start_date, project_end_date: @project.end_date))
      errors.add(:end_date, I18n.t('errors.project_dates_violation'\
          , project_start_date: @project.start_date, project_end_date: @project.end_date))
    end
  end

  def allocated_hours_check
    for as_on in self.start_date..self.end_date
      if (AssignmentAllocation.associate_allocated_hours(self.associate_id, self.id, as_on)\
          + self.hours_per_day) > 24
        allocation_details = '[Skill = ' + self.skill.name + ', Designation = '\
            + self.designation.name + ', Associate = ' + self.associate.name + ']'
        errors.add(:hours_per_day, I18n.t('errors.allocated_hours_violation', allocation_date: as_on\
            , allocation_details: allocation_details))
        break
      end
    end
  end

  def sync_assignment_allocation
    @db_row = AssignmentAllocation.find_by_assignment_id(self.id)
    if !@db_row.nil?
      @db_row.start_date = self.start_date
      @db_row.end_date = self.end_date
      @db_row.hours_per_day = self.hours_per_day
    else
      @db_row = AssignmentAllocation.new(project_id: self.project_id, skill_id: self.skill_id\
          , designation_id: self.designation_id, associate_id: self.associate_id\
          , start_date: self.start_date, end_date: self.end_date, hours_per_day: self.hours_per_day\
          , assignment_id: self.id)
    end
    @db_row.save
  end

  def remove_assignment_allocation
    @db_row = AssignmentAllocation.find_by_assignment_id(self.id)
    @db_row.destroy
  end

  def create_history_record
    @db_row = Assignment.find(self.id)
    @history_row = AssignmentHistory.new(as_on: @db_row.as_on, associate_id: @db_row.associate_id\
        , comments: @db_row.comments, delivery_due_alert_id: @db_row.delivery_due_alert_id\
        , designation_id: @db_row.designation_id, end_date: @db_row.end_date\
        , hours_per_day: @db_row.hours_per_day, invoicing_due_alert_id: @db_row.invoicing_due_alert_id\
        , payment_due_alert_id: @db_row.payment_due_alert_id, project_id: @db_row.project_id\
        , start_date: @db_row.start_date, skill_id: @db_row.skill_id, assignment_id: @db_row.id)
    @history_row.save
  end

  def name_for_timesheet_entry(timesheet_id)
    if !timesheet_id.nil?
      timesheet_id.to_s + ', ' + self.associate.name + ' [' + self.start_date.to_s + ', '\
        + self.end_date.to_s + '], ' + self.project.project_name + ' [' + self.project.client.name\
        + '], ' + self.skill.name + ' [' + self.designation.name + ']'
    else
      self.associate.name + ' [' + self.start_date.to_s + ', '\
        + self.end_date.to_s + '], ' + self.project.project_name + ' [' + self.project.client.name\
        + '], ' + self.skill.name + ' [' + self.designation.name + ']'
    end
  end

  def name_for_assignment
    self.associate.name + ' [' + self.start_date.to_s + ', ' + self.end_date.to_s\
        + '], ' + self.project.project_name + ' [' + self.project.client.name + '], '\
        + self.skill.name + ' [' + self.designation.name + ']'
  end

  after_create :sync_assignment_allocation
  after_update :sync_assignment_allocation

  before_destroy :remove_assignment_allocation

  after_save :create_history_record

  validates :as_on, presence: :true
  validates :associate, presence: :true
  validates :delivery_due_alert, presence: :true
  validates :designation, presence: :true
  validates :end_date, presence: :true
  validates :hours_per_day, presence: :true
  validates :invoicing_due_alert, presence: :true
  validates :payment_due_alert, presence: :true
  validates :project, presence: :true
  validates :skill, presence: :true
  validates :start_date, presence: :true

  validate :start_end_date_check
  validate :hours_check
  validate :project_dates_check
  validate :allocated_hours_check

  validates_uniqueness_of :project_id, scope: [:project_id, :skill_id, :designation_id\
      , :associate_id, :start_date, :end_date]
  validates_uniqueness_of :skill_id, scope: [:project_id, :skill_id, :designation_id\
      , :associate_id, :start_date, :end_date]
  validates_uniqueness_of :designation_id, scope: [:project_id, :skill_id, :designation_id\
      , :associate_id, :start_date, :end_date]
  validates_uniqueness_of :associate_id, scope: [:project_id, :skill_id, :designation_id\
      , :associate_id, :start_date, :end_date]
  validates_uniqueness_of :start_date, scope: [:project_id, :skill_id, :designation_id\
      , :associate_id, :start_date, :end_date]
  validates_uniqueness_of :end_date, scope: [:project_id, :skill_id, :designation_id\
      , :associate_id, :start_date, :end_date]

  belongs_to :payment_due_alert, :class_name => 'FlagStatus', :foreign_key => :payment_due_alert_id
  belongs_to :invoicing_due_alert, :class_name => 'FlagStatus', :foreign_key => :invoicing_due_alert_id
  belongs_to :delivery_due_alert, :class_name => 'FlagStatus', :foreign_key => :delivery_due_alert_id
  belongs_to :skill, :class_name => 'Skill', :foreign_key => :skill_id
  has_many :timesheets, :class_name => 'Timesheet'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
  has_many :assignment_allocations, :class_name => 'AssignmentAllocation'
  belongs_to :associate, :class_name => 'Associate', :foreign_key => :associate_id
  belongs_to :designation, :class_name => 'Designation', :foreign_key => :designation_id
  belongs_to :project, :class_name => 'Project', :foreign_key => :project_id
end
