class TimesheetClocking < ActiveRecord::Base
  def hours_check
    if self.hours <= 0 or self.hours > 24
      errors.add(:hours, I18n.t('errors.hours_check'))
    end
  end

  def self.timesheet_clocked_hours(associate_id, timesheet_id, as_on)
    clocked_hours = 0
    TimesheetClocking.where(associate_id: associate_id, as_on: as_on).each do |tc|
      if tc.timesheet.id != timesheet_id
        clocked_hours += tc.hours
      end
    end
    clocked_hours
  end

  validates :associate, presence: :true
  validates :as_on, presence: :true
  validates :timesheet_id, presence: :true, uniqueness: :true
  validates :hours, presence: :true

  validate :hours_check

  belongs_to :timesheet, :class_name => 'Timesheet', :foreign_key => :timesheet_id
  belongs_to :associate, :class_name => 'Associate', :foreign_key => :associate_id
end
