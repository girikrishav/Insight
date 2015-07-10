include ActiveAdminHelper

ActiveAdmin.register Timesheet, as: I18n.t('active_admin.timesheet') do
  menu :if => proc { menu_accessible?(1) }, :label => I18n.t('active_admin.timesheet').pluralize\
    , :parent => "Operations", :priority => 60

  config.sort_order = 'as_on_desc'

  action_item only: [:show] do
    link_to "Cancel", admin_timesheets_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 1, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:assignment)
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

  show do |ad|
    panel I18n.t('active_admin.timesheet') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for ad do
        row :id
        row :assignment do |a|
          a.assignment.name_for_assignment
        end
        row :as_on
        row :hours
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :assignment, :as => :select, :collection => \
      proc { Assignment.order('as_on DESC').map { |au| ["#{au.name_for_assignment}", au.id] } }
  filter :as_on
  filter :hours
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column 'Id', sortable: :id do |t|
      div(title: t('labels.timesheet_histories')) do
        if TimesheetHistory.where(timesheet_id: t.id).count > 0
          link_to t.id, admin_timesheet_histories_path(timesheet_id: t.id)
        else
          t.id
        end
      end
    end
    column :assignment do |a|
      div(title: a.assignment.name_for_assignment) do
        t('labels.hover_for_details')
      end
    end
    column I18n.t('active_admin.as_on'), sortable: :as_on do |t|
      div(title: t('labels.timesheet_clockings')) do
        link_to t.as_on, admin_timesheet_clockings_path(associate_id: t.assignment.associate.id, as_on: t.as_on)
      end
    end
    column t('labels.hours'), :hours, :sortable => 'hours' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.hours, precision: 2, delimiter: ','
      end
    end
    column :comments
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.timesheet') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" or params[:action] == "create"
        f.input :assignment, as: :select, collection: Assignment.all\
          .map { |a| [a.name_for_assignment, a.id] }
        f.input :as_on, as: :datepicker, input_html: {value: Date.today}
        f.input :hours, input_html: {value: 8}
        f.input :comments
      else
        f.input :assignment, as: :select, collection: Assignment.all\
          .map { |a| [a.name_for_assignment, a.id] }, input_html: {:disabled => true}
        f.input :as_on, as: :datepicker
        f.input :hours
        f.input :comments
      end
      f.actions
    end
  end
end
