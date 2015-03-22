class AssociateType < ActiveRecord::Base
  default_scope {order('rank ASC')}

  has_many :associates, :class_name => 'Associate'
  has_many :associate_histories, :class_name => 'AssociateHistory'
end
