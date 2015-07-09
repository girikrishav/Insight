include ActiveAdminHelper

ActiveAdmin.register AssignmentHistory, as: "Assignment History" do
  menu false

  config.sort_order = 'created_at_desc'

  config.clear_action_items!

  # config.batch_actions = false

  action_item only: [:index] do
    link_to "Cancel", admin_assignments_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_assignment_histories_path(assignment_id: params[:assignment_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:assignment)
      end_of_association_chain.includes(:associate)
      end_of_association_chain.includes(:delivery_due_alert)
      end_of_association_chain.includes(:designation)
      end_of_association_chain.includes(:invoicing_due_alert)
      end_of_association_chain.includes(:payment_due_alert)
      end_of_association_chain.includes(:project)
      end_of_association_chain.includes(:skill)
      if !params[:assignment_id].nil?
        session[:assignment_id] = params[:assignment_id]
      end
      AssignmentHistory.where('assignment_id = ?', session[:assignment_id])
    end
  end

  show do |ah|
    panel 'Assignment History Details' do
      attributes_table_for ah do
        row :id
        row :assignment do
          ah.assignment.id
        end
        row :project do
          ah.project.name
        end
        row :as_on
        row :skill
        row :designation
        row :associate
        row :start_date
        row :end_date
        row :hours_per_day do
          number_with_precision ah.hours_per_day, precision: 0, delimiter: ','
        end
        row :delivery_due_alert
        row :invoicing_due_alert
        row :payment_due_alert
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  index do |ah|
    if self.current_user_rank == self.highest_rank
      selectable_column
    end
    column :id
    column 'At', :created_at
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
    # column :comments
    column '', :id do |t|
      link_to t('actions.view'), admin_assignment_history_path(id: t.id, assignment_id: params[:assignment_id])
    end
  end

  filter :id
  filter :assignment_id
  filter :project, :as => :select, :collection => \
    Project.all.map { |p| ["#{p.project_name}", p.id] }
  filter :as_on
  filter :skill
  filter :designation
  filter :associate
  filter :start_date
  filter :end_date
  filter :delivery_due_alert
  filter :invoicing_due_alert
  filter :payment_due_alert
  filter :hours_per_day
  filter :created_at
  filter :updated_at
  filter :comments
end
