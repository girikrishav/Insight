class PipelineHistory < ActiveRecord::Base
  def bu_currency
    Currency.find(BusinessUnit.find(self.owner_business_unit_id).currency_id).name
  end

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :owner_business_unit_id
  belongs_to :delivery_manager_associate, :class_name => 'Associate', :foreign_key => :delivery_manager_associate_id
  belongs_to :account_manager_associate, :class_name => 'Associate', :foreign_key => :account_manager_associate_id
  belongs_to :estimator_associate, :class_name => 'Associate', :foreign_key => :estimator_associate_id
  belongs_to :sales_associate, :class_name => 'Associate', :foreign_key => :sales_associate_id
  belongs_to :client, :class_name => 'Client', :foreign_key => :client_id
  belongs_to :pipeline_status, :class_name => 'PipelineStatus', :foreign_key => :pipeline_status_id
  belongs_to :pipeline, :class_name => 'Pipeline', :foreign_key => :pipeline_id
  belongs_to :project_type, :class_name => 'ProjectType', :foreign_key => :project_type_id
end
