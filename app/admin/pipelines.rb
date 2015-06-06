include ActiveAdminHelper

ActiveAdmin.register Pipeline, as: "Pipeline" do
  menu :if => proc { menu_accessible?(50) }, :label => "Pipeline", :parent => "Operations", :priority => 40

  config.sort_order = 'expected_start_desc'

  action_item only: [:new] do
    link_to t('button_labels.new_client'), new_admin_client_path(from_path: 'new_admin_pipeline_path')
  end

  action_item only: [:show] do
    link_to "Cancel", admin_pipelines_path
  end

  batch_action :convert do |ids|
    @success_count = 0
    Pipeline.find(ids).each do |p|
      @project = Project.find_by_pipeline_id(p.id)
      if @project.nil?
        @new_project_status = ProjectStatus.find_by_name('New').id
        @project = Project.create(account_manager_associate_id: p.account_manager_associate_id\
            , as_on: Date.today, booking_amount: p.expected_value, client_id: p.client_id\
            , delivery_manager_associate_id: p.delivery_manager_associate_id, end_date: p.expected_end\
            , estimator_associate_id: p.estimator_associate_id\
            , owner_business_unit_id: p.owner_business_unit_id, pipeline_id: p.id\
            , project_description: p.project_description, project_name: p.project_name\
            , project_status_id: @new_project_status\
            , project_type_id: p.project_type_id, sales_associate_id: p.sales_associate_id\
            , start_date: p.expected_start, comments: nil)
        if  @project.save
          @success_count += 1
        else
          p.comments = @project.errors.messages
          p.save
        end
      else
        p.comments = t('errors.pipeline_already_assigned', pipeline_id: p.id, project_id: @project.id)
        p.save
      end
    end
    flash[:messages] = t('messages.pipelines_converted', success_count: @success_count\
        , selected_count: ids.count)
    if @success_count > 0
      redirect_to admin_projects_path
    else
      redirect_to admin_pipelines_path
    end
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
      Pipeline.where(id: Pipeline.allowed_ids(@current_user_rank, @highest_rank, @current_user_id))
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
    panel 'Pipeline Details' do
      attributes_table_for p do
        row :id
        row :as_on
        row :project_name
        row :expected_start
        row :expected_end
        row :bu_currency
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
  filter :client, :as => :select, :collection => \
            proc { Client.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :project_type
  filter :pipeline_status
  filter :owner_business_unit
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
      div(title: t('labels.pipeline_histories')) do
        if PipelineHistory.where(pipeline_id: t.id).count > 0
          link_to t.id, admin_pipeline_histories_path(pipeline_id: t.id)
        else
          t.id
        end
      end
    end
    column 'BU', :business_unit
    column :client
    column 'Project', :project_name
    # column :as_on
    column 'Start', :expected_start
    column 'End', :expected_end
    column 'Type', :project_type
    column 'In', :bu_currency, sortable: false
    column 'Value', :expected_value, :sortable => 'expected_value' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.expected_value, precision: 0, delimiter: ','
      end
    end
    column 'Status', :pipeline_status do |s|
      PipelineStatus.find(s.pipeline_status_id).name
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Pipeline Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :business_unit, :as => :select, :collection => BusinessUnit.all \
            .map { |bu| ["#{bu.name_with_currency}", bu.id] }
        f.input :client
        f.input :project_name, :label => 'Project'
        f.input :as_on, as: :datepicker, :input_html => {:value => Date.today}
        f.input :expected_start, :label => 'Start', as: :datepicker
        f.input :expected_end, :label => 'End', as: :datepicker
        f.input :project_type, :label => 'Type'
        f.input :pipeline_status, :label => 'Status'
      else
        f.input :business_unit, :as => :select, :collection => BusinessUnit.all \
            .map { |bu| ["#{bu.name_with_currency}", bu.id] }
        f.input :client, :input_html => {:disabled => true}
        f.input :project_name, :label => 'Project'
        f.input :as_on, as: :datepicker
        f.input :expected_start, :label => 'Start', as: :datepicker
        f.input :expected_end, :label => 'End', as: :datepicker
        f.input :project_type, :label => 'Type'
        f.input :pipeline_status, :label => 'Status'
      end
      if params[:action] != "new" && params[:action] != "create"
        f.input :bu_currency, :label => 'Currency', :input_html => {:disabled => true}
      end
      f.input :expected_value, :label => 'Value'
      f.input :project_description
      f.input :sales_associate
      f.input :estimator_associate
      f.input :account_manager_associate
      f.input :delivery_manager_associate
      f.input :comments
    end
    f.actions
  end
end
