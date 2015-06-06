include ActiveAdminHelper

ActiveAdmin.register Project, as: "Project" do
  menu :if => proc { menu_accessible?(25) }, :label => "Projects", :parent => "Operations", :priority => 50

  config.sort_order = 'start_date_desc'

  action_item only: [:new] do
    link_to t('button_labels.new_client'), new_admin_client_path(from_path: 'new_admin_project_path')
  end

  action_item only: [:show] do
    link_to "Cancel", admin_projects_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 25, url_for)
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
      Project.where(id: Project.allowed_ids(@current_user_rank, @highest_rank, @current_user_id))
    end

    # To redirect create and update actions redirect to index page upon submit.
    def create
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end
  end

  show do |p|
    panel 'Project Details' do
      attributes_table_for p do
        row :id
        row :as_on
        row :project_name
        row :start_date
        row :end_date
        row :bu_currency
        row :booking_amount do
          number_with_precision p.booking_amount, precision: 0, delimiter: ','
        end
        row :project_description
        row :client
        row :project_type
        row :project_status
        row "BU" do
          p.business_unit
        end
        row :sales_associate
        row :estimator_associate
        row :account_manager_associate
        row :delivery_manager_associate
        if !p.pipeline.nil?
          row "Pipeline" do
            p.pipeline.complete_name
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
  filter :pipeline, :as => :select, :collection => \
      proc { Pipeline.order('project_name ASC').map { |au| ["#{au.complete_name}", au.id] } }
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
    selectable_column
    column 'Id', sortable: :id do |t|
      div(title: t('labels.project_histories')) do
        if ProjectHistory.where(project_id: t.id).count > 0
          link_to t.id, admin_project_histories_path(project_id: t.id)
        else
          t.id
        end
      end
    end
    column 'BU', :business_unit do |t|
      div(title: t('labels.staffing_requirements')) do
        link_to t.business_unit.name, admin_staffing_requirements_path(project_id: t.id)
      end
    end
    column 'Client', :client do |t|
      div(title: t('labels.assignments')) do
        link_to t.client.name, admin_assignments_path(project_id: t.id)
      end
    end
    column 'Project', :project_name
    column 'Start', :start_date
    column 'End', :end_date
    column 'Type', :project_type
    column 'In', :bu_currency
    column 'Value', :booking_amount, :sortable => 'booking_amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.booking_amount, precision: 0, delimiter: ','
      end
    end
    column 'Status', :project_status do |s|
      ProjectStatus.find(s.project_status_id).name
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Project Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :business_unit, :as => :select, :collection => BusinessUnit.all \
            .map { |bu| ["#{bu.name}" + " [Currency = #{bu.bu_currency}]", bu.id] }
        f.input :client
        f.input :project_name, :label => 'Project'
        f.input :as_on, as: :datepicker, :input_html => {:value => Date.today}
        f.input :start_date, :label => 'Start', as: :datepicker
        f.input :end_date, :label => 'End', as: :datepicker
        f.input :project_type, :label => 'Type'
        f.input :project_status, :label => 'Status'
      else
        f.input :business_unit, :as => :select, :collection => BusinessUnit.all \
            .map { |bu| ["#{bu.name}" + " [Currency = #{bu.bu_currency}]", bu.id] }
        f.input :client, :input_html => {:disabled => true}
        f.input :project_name, :label => 'Project'
        f.input :as_on, as: :datepicker
        f.input :start_date, :label => 'Start', as: :datepicker
        f.input :end_date, :label => 'End', as: :datepicker
        f.input :project_type, :label => 'Type'
        f.input :project_status, :label => 'Status'
      end
      if params[:action] != "new" && params[:action] != "create"
        f.input :bu_currency, :label => 'Currency', :input_html => {:disabled => true}
      end
      f.input :booking_amount, :label => 'Value'
      f.input :sales_associate
      f.input :project_description
      f.input :estimator_associate
      f.input :account_manager_associate
      f.input :delivery_manager_associate
      f.input :pipeline, :label => 'Pipeline'\
          , :as => :select, :collection => \
          Pipeline.allowed(self.current_user_rank, self.highest_rank, self.current_user_id)\
          # .map { |p| ["BU = #{p.bu_name}" + ", Client = #{p.client_name}"\
      .map { |p| ["BU = #{p.bu_name}" + ", Client = #{p.client_name}"\
          + ", Project = #{p.project_name}" + ", As on = " + p.as_on.to_s\
          + " [Currency = #{p.bu_currency}]", p.id] }
      f.input :comments
    end
    f.actions
  end
end
