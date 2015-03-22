class TimesheetHistory < ActiveRecord::Base
  belongs_to :timesheet, :class_name => 'Timesheet', :foreign_key => :timesheet_id
  belongs_to :associate, :class_name => 'Associate', :foreign_key => :associate_id
end
