class AssociateHistory < ActiveRecord::Base
  belongs_to :user, :class_name => 'AdminUser', :foreign_key => :user_id
  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :business_unit_id
  belongs_to :active, :class_name => 'FlagStatus', :foreign_key => :is_active
  belongs_to :associate_type, :class_name => 'AssociateType', :foreign_key => :associate_type_id
  belongs_to :associate, :class_name => 'Associate', :foreign_key => :associate_id
  belongs_to :manager, :class_name => 'Associate', :foreign_key => :manager_id
  belongs_to :department, :class_name => 'Department', :foreign_key => :department_id
end
