include ActiveAdminHelper

ActiveAdmin.register PipelineHistory, as: "Pipeline History" do
  menu false

  config.sort_order = 'created_at_desc'

  config.clear_action_items!

  # config.batch_actions = false

  action_item only: [:index] do
    link_to "Cancel", admin_pipelines_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_pipeline_histories_path(pipeline_id: params[:pipeline_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:client)
      end_of_association_chain.includes(:project_type)
      end_of_association_chain.includes(:pipeline_status)
      end_of_association_chain.includes(:business_unit)
      end_of_association_chain.includes(:sales_associate)
      end_of_association_chain.includes(:estimator_associate)
      end_of_association_chain.includes(:account_manager_associate)
      end_of_association_chain.includes(:delivery_manager_associate)
      if !params[:pipeline_id].nil?
        session[:pipeline_id] = params[:pipeline_id]
      end
      PipelineHistory.where('pipeline_id = ?', session[:pipeline_id])
    end
  end

  show do |p|
    panel 'Pipeline History Details' do
      attributes_table_for p do
        row :id
        row :as_on
        row :project_name
        row :expected_start
        row :expected_end
        row "In" do |ph|
          ph.bu_currency
        end
        row :expected_value do
          number_with_precision p.expected_value, precision: 0, delimiter: ','
        end
        row :project_description
        row :client
        row :project_type
        row :pipeline_status
        row "BU" do
          p.business_unit
        end
        row :sales_associate
        row :estimator_associate
        row :account_manager_associate
        row :delivery_manager_associate
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :as_on
  filter :project_name
  filter :expected_start
  filter :expected_end
  filter :expected_value
  filter :project_description
  filter :client
  filter :project_type
  filter :pipeline_status
  filter :business_unit
  filter :sales_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :estimator_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :account_manager_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :delivery_manager_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    if self.current_user_rank == self.highest_rank
      selectable_column
    end
    column :id
    column 'At', :created_at
    column 'BU', :business_unit
    column :client
    column 'Project', :project_name
    column 'Start', :expected_start
    column 'End', :expected_end
    column 'Type', :project_type, :sortable => 'project_type.name'
    column 'In', :bu_currency
    column 'Value', :expected_value, :sortable => 'expected_value' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.expected_value, precision: 0, delimiter: ','
      end
    end
    column 'Status', :pipeline_status, :sortable => 'pipeline_status.name' do |s|
      PipelineStatus.find(s.pipeline_status_id).name
    end
    # column :comments
    column '', :id do |t|
      link_to t('actions.view'), admin_pipeline_history_path(id: t.id, pipeline_id: params[:pipeline_id])
    end
  end
end
