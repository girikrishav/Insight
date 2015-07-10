include ActiveAdminHelper

ActiveAdmin.register ProjectHistory, as: I18n.t('active_admin.project_history') do
  menu false

  config.sort_order = 'created_at_desc'

  config.clear_action_items!

  action_item only: [:index] do
    link_to I18n.t('button_labels.cancel'), admin_projects_path
  end

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_project_histories_path(project_id: params[:project_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:clients)
      end_of_association_chain.includes(:project_types)
      end_of_association_chain.includes(:pipeline_statuses)
      end_of_association_chain.includes(:business_units)
      end_of_association_chain.includes(:sales_associate)
      end_of_association_chain.includes(:estimator_associate)
      end_of_association_chain.includes(:account_manager_associate)
      end_of_association_chain.includes(:delivery_manager_associate)
      end_of_association_chain.includes(:pipeline)
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      ProjectHistory.where('project_id = ?', session[:project_id])
    end
  end

  show do |p|
    panel I18n.t('active_admin.project_history') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for p do
        row :id
        row :as_on
        row :project_name
        row :start_date
        row :end_date
        row I18n.t('active_admin.in') do |sr|
          p.bu_currency
        end
        row :booking_amount do
          number_with_precision p.booking_amount, precision: 0, delimiter: ','
        end
        row :project_description
        row :client
        row :project_type
        row :project_status
        row I18n.t('active_admin.bu') do
          p.business_unit
        end
        row :sales_associate
        row :estimator_associate
        row :account_manager_associate
        row :delivery_manager_associate
        if !p.pipeline.nil?
          row I18n.t('active_admin.pipeline') do
            I18n.t('active_admin.bu') + " = " + p.pipeline.bu_name \
            + ", " + I18n.t('active_admin.client') + " = " + p.pipeline.client_name\
            + ", " + I18n.t('active_admin.project') + " = " + p.pipeline.project_name\
            + ", " + I18n.t('active_admin.as_on') + " = " + p.pipeline.as_on.to_s
          end
        else
          row :pipeline
        end
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :as_on
  filter :project_name
  filter :start_date
  filter :end_date
  filter :booking_amount
  filter :project_description
  filter :client
  filter :project_type
  filter :project_status
  filter :business_unit
  filter :sales_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :estimator_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :account_manager_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :delivery_manager_associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :pipeline, :as => :select, :collection => \
      proc { Pipeline.all.map { |au| ["#{au.name}", au.id] } }
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    if self.current_user_rank == self.highest_rank
      selectable_column
    end
    column :id
    column I18n.t('active_admin.at'), :created_at
    column I18n.t('active_admin.bu'), :business_unit, :sortable => 'business_units.name'
    column :client, :sortable => 'clients.name'
    column I18n.t('active_admin.project'), :project_name
    # column :as_on
    column I18n.t('active_admin.start'), :start_date
    column I18n.t('active_admin.end'), :end_date
    column I18n.t('active_admin.type'), :project_type, :sortable => 'project_types.name'
    column I18n.t('active_admin.in'), :bu_currency
    column I18n.t('active_admin.value'), :booking_amount, :sortable => 'booking_amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.booking_amount, precision: 0, delimiter: ','
      end
    end
    column I18n.t('active_admin.status'), :project_status, :sortable => 'project_statuses.name' do |s|
      ProjectStatus.find(s.project_status_id).name
    end
    # column :comments
    column '', :id do |t|
      link_to t('actions.view'), admin_project_history_path(id: t.id, project_id: params[:project_id])
    end
  end
end
