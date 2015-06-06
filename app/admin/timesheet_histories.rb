include ActiveAdminHelper

ActiveAdmin.register TimesheetHistory, as: "Timesheet History" do
  menu false

  config.sort_order = 'created_at_desc'

  config.clear_action_items!

  action_item only: [:index] do
    link_to "Cancel", admin_timesheets_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_timesheet_histories_path(timesheet_id: params[:timesheet_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 1, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:associate)
      end_of_association_chain.includes(:timesheet)
      if !params[:timesheet_id].nil?
        session[:timesheet_id] = params[:timesheet_id]
      end
      TimesheetHistory.where('timesheet_id = ?', session[:timesheet_id])
    end

    def index
      if !params[:timesheet_id].nil?
        session[:timesheet_id] = params[:timesheet_id]
      end
      @timesheet_title = t('labels.timesheet_history_index_page'\
          , timesheet_title: Timesheet.find(session[:timesheet_id]).id)
      index!
    end
  end

  show do |th|
    panel 'Timesheet History Details' do
      attributes_table_for th do
        row :id
        row :timesheet do |p|
          p.timesheet.name_for_timesheet
        end
        row :as_on
        row :hours do
          number_with_precision th.hours, precision: 0, delimiter: ','
        end
        row :comments
      end
    end
  end

  filter :as_on
  filter :hours
  filter :comments
  filter :created_on
  filter :updated_on

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
      link_to t('actions.view'), admin_timesheet_history_path(id: t.id\
          , timesheet_id: params[:timesheet_id])
    end
  end
end
