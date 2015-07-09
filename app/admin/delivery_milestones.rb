include ActiveAdminHelper

ActiveAdmin.register DeliveryMilestone, as: "Delivery Milestone" do
  menu false

  config.sort_order = 'due_date_desc'

  action_item only: [:index] do
    link_to "Cancel", admin_projects_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_delivery_milestones_path(project_id: params[:project_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:project)
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      DeliveryMilestone.where(project_id: session[:project_id])
    end

    def index
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      @project_title = t('labels.delivery_milestone_index_page'\
          , project_title: Project.find(session[:project_id]).id)
      index!
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

  show do |sr|
    panel 'Delivery Milestone Details' do
      attributes_table_for sr do
        row :id
        row :project do |p|
          p.project.name
        end
        row :name
        row :description
        row :due_date
        row :last_reminder_date
        row :completion_date
        row :comments
      end
    end
  end

  filter :name
  filter :description
  filter :due_date
  filter :last_reminder_date
  filter :completion_date
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |p| @project_title } do
    selectable_column
    column :id
    column :project do |p|
      div(title: p.project.name) do
        t('labels.hover_for_details')
      end
    end
    column :name
    column :description
    column :due_date
    column :last_reminder_date
    column :completion_date
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Delivery Milestone Details" do
      f.input :project, as: :select, collection: Project.all.map { |p| [p.name, p.id] }\
          , input_html: {:disabled => true, selected: Project.find(session[:project_id]).id}
      if params[:action] == "new" or params[:action] == "create"
        f.input :name
      else
        f.input :name, input_html: {:disabled => true}
      end
      f.input :description
      f.input :due_date, as: :datepicker
      f.input :last_reminder_date, as: :datepicker, input_html: {:disabled => true}
      f.input :completion_date, as: :datepicker
      f.input :comments
      f.actions
    end
  end
end
