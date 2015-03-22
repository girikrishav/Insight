class Timesheet < ActiveRecord::Base
  def sync_timesheet_allocation
    @db_row = TimesheetClocking.find_by_timesheet_id(self.id)
    if !@db_row.nil?
      @db_row.hours = self.hours
    else
      @db_row = TimesheetClocking.new(as_on: self.as_on, associate_id: self.assignment.associate.id\
          , comments: self.comments, hours: self.hours, timesheet_id: self.id)
    end
    @db_row.save
  end

  def remove_timesheet_allocation
    @db_row = TimesheetClocking.find_by_timesheet_id(self.id)
    @db_row.destroy
  end

  def hours_check
    if self.hours <= 0 or self.hours > 24
      errors.add(:hours, I18n.t('errors.hours_check'))
    end
  end

  def clocked_hours_check
    if (TimesheetClocking.timesheet_clocked_hours(self.assignment.associate.id, self.id, self.as_on)\
          + self.hours) > 24
      timesheet_details = self.name
      errors.add(:hours, I18n.t('errors.clocked_hours_violation', timesheet_details: timesheet_details\
            , clocking_date: as_on))
    end
  end

  def create_history_record
    @db_row = Timesheet.find(self.id)
    @history_row = TimesheetHistory.new(as_on: @db_row.as_on, associate_id: @db_row.assignment.associate.id\
        , comments: @db_row.comments, hours: @db_row.hours, timesheet_id: self.id)
    @history_row.save
  end

  def name_for_timesheet
    self.assignment.name_for_timesheet_entry(self.id)
  end

  def timesheet_assignment_check
    if self.as_on < self.assignment.start_date or self.as_on > self.assignment.end_date
      errors.add(:as_on, I18n.t('errors.timesheet_assignment_violation'))
    end
  end

  validates :assignment, presence: :true
  validates :as_on, presence: :true
  validates :hours, presence: :true

  validates_uniqueness_of :assignment_id, scope: [:assignment_id, :as_on]
  validates_uniqueness_of :as_on, scope: [:assignment_id, :as_on]

  validate :hours_check
  validate :clocked_hours_check
  validate :timesheet_assignment_check

  after_create :sync_timesheet_allocation
  after_update :sync_timesheet_allocation

  before_destroy :remove_timesheet_allocation

  after_save :create_history_record

  has_many :timesheet_histories, :class_name => 'TimesheetHistory'
  has_many :timesheet_clockings, :class_name => 'TimesheetClocking'
  belongs_to :assignment, :class_name => 'Assignment', :foreign_key => :assignment_id
end
