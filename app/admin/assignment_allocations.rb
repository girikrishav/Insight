include ActiveAdminHelper

ActiveAdmin.register AssignmentAllocation, as: "Assignment Allocation" do
  menu false

  config.sort_order = 'start_date_desc'

  config.clear_action_items!
  actions  :index, :show 

  action_item only: [:index] do
    link_to "Cancel", admin_associates_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_assignment_allocations_path(associate_id: params[:associate_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:associate)
      end_of_association_chain.includes(:designation)
      end_of_association_chain.includes(:project)
      end_of_association_chain.includes(:skill)
      end_of_association_chain.includes(:assignment)
      if !params[:associate_id].nil?
        session[:associate_id] = params[:associate_id]
      end
      AssignmentAllocation.where(associate_id: session[:associate_id])
    end

    def index
      if !params[:associate_id].nil?
        session[:associate_id] = params[:associate_id]
      end
      @associate_title = t('labels.assignment_allocation_index_page'\
          , associate_title: Associate.find(session[:associate_id]).id)
      index!
    end

    # To redirect create and update actions redirect to index page upon submit.
    def create
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end

    def update
      # AssignmentAllocation.delay.send_mail("giri@cognitiveclouds.com", "girikrishva@gmail.com", "Banjo", "Banjo detail.")
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end
  end

  show do |sr|
    panel 'Assignment Allocation Details' do
      attributes_table_for sr do
        row :id
        row :project do |p|
          p.project.complete_name
        end
        row :assignment do |a|
          a.assignment.id
        end
        row :skill
        row :designation
        row :associate
        row :start_date
        row :end_date
        row :hours_per_day do
          number_with_precision sr.hours_per_day, precision: 0, delimiter: ','
        end
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :project, :as => :select, :collection => \
      proc { Project.all.map { |au| ["#{au.complete_name}", au.id] } }
  filter :assignment, :as => :select, :collection => \
      proc { Assignment.all.map { |au| ["#{au.name_for_assignment}", au.id] } }
  filter :skill
  filter :designation
  filter :associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :start_date
  filter :end_date
  filter :hours_per_day
  filter :comments
  filter :created_at
  filter :updated_at


  index title: proc { |p| @associate_title } do
    selectable_column
    column :id
    column :assignment do |a|
      a.assignment.id
    end
    column :project do |p|
      div(title: p.project.complete_name) do
        t('labels.hover_for_details')
      end
    end
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
    # column :comments
    column '', :id do |t|
      link_to t('actions.view'), admin_assignment_allocation_path(id: t.id\
          , associate_id: params[:associate_id])
    end
  end
end
