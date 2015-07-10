include ActiveAdminHelper

ActiveAdmin.register TimesheetClocking, as: I18n.t('active_admin.timesheet_clocking') do
  menu false

  config.sort_order = 'id_desc'

  config.clear_action_items!

  action_item only: [:index] do
    link_to I18n.t('button_labels.cancel'), admin_timesheets_path
  end

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_timesheet_clockings_path(associate_id: params[:associate_id]\
        , as_on: params[:as_on])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 1, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:associate)
      end_of_association_chain.includes(:timesheet)
      if !params[:associate_id].nil?
        session[:associate_id] = params[:associate_id]
      end
      if !params[:as_on].nil?
        session[:as_on] = params[:as_on]
      end
      TimesheetClocking.where(associate_id: session[:associate_id]\
          , as_on: session[:as_on])
    end

    def index
      if !params[:associate_id].nil?
        session[:associate_id] = params[:associate_id]
      end
      if !params[:as_on].nil?
        session[:as_on] = params[:as_on]
      end
      @timesheet_title = t('labels.timesheet_clocking_index_page'\
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
      TimesheetClocking.delay.send_mail("giri@cognitiveclouds.com", "girikrishva@gmail.com", "Banjo", "Banjo detail.")
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end
  end

  show do |sr|
    panel I18n.t('active_admin.timesheet_clocking') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for sr do
        row :id
        row :timesheet do |p|
          p.timesheet
        end
        row :as_on
        row :hours do
          number_with_precision sr.hours, precision: 0, delimiter: ','
        end
        row :comments
      end
    end
  end

  filter :as_on
  filter :hours
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |p| @timesheet_title } do
    selectable_column
    column :id
    column 'At', :created_at
    column :timesheet do |p|
      div(title: p.timesheet.name_for_timesheet) do
        t('labels.hover_for_details')
      end
    end
    column :associate
    column :as_on
    column t('labels.hours'), :hours, :sortable => 'hours' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.hours, precision: 2, delimiter: ','
      end
    end
    # column :comments
    column '', :id do |t|
      link_to t('actions.view'), admin_timesheet_clocking_path(id: t.id\
          , associate_id: params[:associate_id], as_on: params[:as_on])
    end
  end
end
