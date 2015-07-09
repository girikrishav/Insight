include ActiveAdminHelper

ActiveAdmin.register Assignment, as: "Assignment" do
  menu false

  config.sort_order = 'start_date_desc'

  action_item only: [:index] do
    link_to "Cancel", admin_projects_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_assignments_path(project_id: params[:project_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:associate)
      end_of_association_chain.includes(:delivery_due_alert)
      end_of_association_chain.includes(:designation)
      end_of_association_chain.includes(:invoicing_due_alert)
      end_of_association_chain.includes(:payment_due_alert)
      end_of_association_chain.includes(:project)
      end_of_association_chain.includes(:skill)
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      Assignment.where(project_id: session[:project_id])
    end

    def index
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      @project_title = t('labels.assignment_index_page'\
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
    panel 'Assignment Details' do
      attributes_table_for sr do
        row :id
        row :project do |p|
          p.project.name
        end
        row :as_on
        row :skill
        row :designation
        row :associate
        row :start_date
        row :end_date
        row :hours_per_day do
          number_with_precision sr.hours_per_day, precision: 0, delimiter: ','
        end
        row :delivery_due_alert
        row :invoicing_due_alert
        row :payment_due_alert
        row :comments
      end
    end
  end

  filter :as_on
  filter :skill
  filter :designation
  filter :associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :start_date
  filter :end_date
  filter :hours_per_day
  filter :delivery_due_alert
  filter :invoicing_due_alert
  filter :payment_due_alert
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |p| @project_title } do
    selectable_column
    column 'Id', sortable: :id do |t|
      div(title: t('labels.assignment_histories')) do
        if AssignmentHistory.where(assignment_id: t.id).count > 0
          link_to t.id, admin_assignment_histories_path(assignment_id: t.id)
        else
          t.id
        end
      end
    end
    column :project do |p|
      div(title: p.project.name) do
        t('labels.hover_for_details')
      end
    end
    column :as_on
    column :skill
    column :designation
    column :associate
    column :start_date
    column :end_date
    column t('labels.hours_per_day'), :hours_per_day, :sortable => 'hours_per_day' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.hours_per_day, precision: 2, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Assignment Details" do
      f.input :project, as: :select, collection: Project.all.map { |p| [p.name, p.id] }\
          , input_html: {:disabled => true, selected: Project.find(session[:project_id]).id}
      if params[:action] == "new" or params[:action] == "create"
        f.input :as_on, as: :datepicker, input_html: {value: Date.today}
        f.input :skill, as: :select, collection: Skill.applicable_skills.map { |a| [a.name, a.id] }\
            , include_blank: true
        f.input :designation, as: :select, collection: \
            option_groups_from_collection_for_select(Skill.order(:rank), :applicable_designations\
            , :name, :designation_id, :designation_name), include_blank: true
        f.input :associate, as: :select, collection: \
            option_groups_from_collection_for_select(ServiceRate.order(:id), :applicable_associates\
            , :skill_designation, :id, :name), include_blank: true
        f.input :start_date, as: :datepicker, input_html: {value: Date.today}
        f.input :end_date, as: :datepicker, input_html: {value: Date.today}
        f.input :hours_per_day, input_html: {value: 8}
        f.input :delivery_due_alert, as: :select, collection: FlagStatus.all\
          .map { |fs| [fs.name, fs.id] }, selected: FlagStatus.find_by_name('No').id\
          , include_blank: false
        f.input :invoicing_due_alert, as: :select, collection: FlagStatus.all\
          .map { |fs| [fs.name, fs.id] }, selected: FlagStatus.find_by_name('No').id\
          , include_blank: false
        f.input :payment_due_alert, as: :select, collection: FlagStatus.all\
          .map { |fs| [fs.name, fs.id] }, selected: FlagStatus.find_by_name('No').id\
          , include_blank: false
      else
        f.input :as_on, as: :datepicker, input_html: {:disabled => true}
        f.input :skill, input_html: {:disabled => true}
        f.input :designation, input_html: {:disabled => true}
        f.input :associate, input_html: {:disabled => true}
        f.input :start_date, as: :datepicker
        f.input :end_date, as: :datepicker
        f.input :hours_per_day
        f.input :delivery_due_alert, include_blank: false
        f.input :invoicing_due_alert, include_blank: false
        f.input :payment_due_alert, include_blank: false
        f.input :comments
      end
      f.actions
    end
  end
end
