class AssignmentHistory < ActiveRecord::Base
  belongs_to :payment_due_alert, :class_name => 'FlagStatus', :foreign_key => :payment_due_alert_id
  belongs_to :invoicing_due_alert, :class_name => 'FlagStatus', :foreign_key => :invoicing_due_alert_id
  belongs_to :delivery_due_alert, :class_name => 'FlagStatus', :foreign_key => :delivery_due_alert_id
  belongs_to :skill, :class_name => 'Skill', :foreign_key => :skill_id
  belongs_to :assignment, :class_name => 'Assignment', :foreign_key => :assignment_id
  belongs_to :associate, :class_name => 'Associate', :foreign_key => :associate_id
  belongs_to :designation, :class_name => 'Designation', :foreign_key => :designation_id
  belongs_to :project, :class_name => 'Project', :foreign_key => :project_id
end
