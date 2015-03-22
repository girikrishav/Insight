include ActiveAdminHelper

ActiveAdmin.register StaffingRequirement, as: "Staffing Requirement" do
  menu false

  config.sort_order = 'start_date_desc'

  action_item only: [:index] do
    link_to "Cancel", admin_projects_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_staffing_requirements_path(project_id: params[:project_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:designation)
      end_of_association_chain.includes(:fulfilled)
      end_of_association_chain.includes(:skill)
      end_of_association_chain.includes(:project)
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      StaffingRequirement.where(project_id: session[:project_id])
    end

    def index
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      @project_title = t('labels.staffing_requirement_index_page'\
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
    panel 'Staffing Requirement Details' do
      attributes_table_for sr do
        row :id
        row :project do |p|
          p.project.complete_name
        end
        row :skill
        row :designation
        row :start_date
        row :end_date
        row :number_required
        row :hours_per_day do
          number_with_precision sr.hours_per_day, precision: 0, delimiter: ','
        end
        row :fulfilled
        row :comments
      end
    end
  end

  filter :skill
  filter :designation
  filter :start_date
  filter :end_date
  filter :number_required
  filter :hours_per_day
  filter :fulfilled
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |p| @project_title } do
    selectable_column
    column :id
    column :project do |p|
      div(title: p.project.complete_name) do
        t('labels.hover_for_details')
      end
    end
    column :skill
    column :designation
    column :start_date
    column :end_date
    column t('labels.staff'), :number_required, :sortable => 'number_required' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.number_required, precision: 0, delimiter: ','
      end
    end
    column t('labels.hours_per_day'), :hours_per_day, :sortable => 'hours_per_day' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.hours_per_day, precision: 2, delimiter: ','
      end
    end
    column :fulfilled
    actions
  end

  form do |f|
    f.inputs "Staffing Requirement Details" do
      f.input :project, as: :select, collection: Project.all.map { |p| [p.complete_name, p.id] }\
          , input_html: {:disabled => true, selected: Project.find(session[:project_id]).id}
      if params[:action] == "new" || params[:action] == "create"
        f.input :skill
        f.input :designation, as: :select, collection: Designation.all\
            .map { |d| [d.name, d.id] }, selected: Designation.find_by_name('Engineer').id
        f.input :start_date, as: :datepicker, input_html: {value: Date.today}
        f.input :end_date, as: :datepicker, input_html: {value: Date.today}
        f.input :number_required, input_html: {value: 1}
        f.input :hours_per_day, input_html: {value: 8}
        f.input :fulfilled, as: :select, collection: FlagStatus.all\
            .map { |fs| [fs.name, fs.id] }, selected: FlagStatus.find_by_name('No').id
      else
        f.input :skill, input_html: {:disabled => true}
        f.input :designation, as: :select, collection: Designation.all\
            .map { |d| [d.name, d.id] }, selected: Designation.find_by_name('Engineer').id\
            , input_html: {:disabled => true}
        f.input :start_date, as: :datepicker
        f.input :end_date, as: :datepicker
        f.input :number_required
        f.input :hours_per_day
        f.input :fulfilled
      end
      f.input :comments
      f.actions
    end
  end
end
