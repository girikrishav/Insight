include ActiveAdminHelper

ActiveAdmin.register InvoiceHeader, as: I18n.t('active_admin.project_invoice') do
  menu false

  config.sort_order = 'invoice_date_desc_and_id_desc'

  action_item only: [:index] do
    link_to I18n.t('button_labels.cancel'), admin_projects_path
  end

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_project_invoices_path(project_id: params[:project_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:project)
      end_of_association_chain.includes(:invoice_status)
      end_of_association_chain.includes(:term)
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      InvoiceHeader.where(project_id: session[:project_id])
    end

    def index
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      @project_title = t('labels.invoice_header_index_page'\
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

  show title: "" do |ih|
    panel I18n.t('active_admin.project_invoice') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for ih do
        row :id
        row :project do |p|
          p.project.name
        end
        row :description
        row :invoice_date
        row I18n.t('active_admin.in') do |ih|
          ih.bu_currency
        end
        row :amount do |ih|
          number_with_precision ih.amount, precision: 2, delimiter: ','
        end
        row :unpaid do |ih|
          number_with_precision ih.unpaid, precision: 2, delimiter: ','
        end
        row :invoice_status
        row (I18n.t('active_admin.term').pluralize) { |r| r.term}
        row :due_date
        row :comments
      end
    end
  end

  filter :description
  filter :invoice_date
  filter :invoice_status, :as => :select, :collection => \
      proc { InvoiceStatus.order('name ASC').map { |is| ["#{is.name}", is.id] } }
  # filter :term, :as => :select, :collection => \
  #     proc { Term.order('name ASC').map { |t| ["#{t.name}", t.id] } }
  filter :due_date
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
    column :description
    column :invoice_date
    column I18n.t('active_admin.in'), :bu_currency
    column I18n.t('active_admin.amount'), :amount, :sortable => 'amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.amount, precision: 2, delimiter: ','
      end
    end
    column I18n.t('active_admin.unpaid'), :amount, :sortable => 'unpaid' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.unpaid, precision: 2, delimiter: ','
      end
    end
    column :invoice_status
    # column 'Terms', :term
    column :due_date
    actions dropdown: :true do |ih|
      item I18n.t('active_admin.project_invoice_line').pluralize\
        , admin_project_invoice_lines_path(project_id: ih.project.id\
        , invoice_header_id: ih.id)
      item I18n.t('active_admin.project_invoice_adder').pluralize\
        , admin_project_invoice_adders_path(project_id: ih.project.id\
        , invoice_header_id: ih.id)
    end
  end

  form do |f|
    f.inputs I18n.t('active_admin.project_invoice') + ' ' + I18n.t('active_admin.detail').pluralize do
      f.input :project, as: :select, collection: Project.all.map { |p| [p.name, p.id] }\
          , input_html: {:disabled => true, selected: Project.find(session[:project_id]).id}
      if params[:action] == "new" or params[:action] == "create"
        f.input :description
        f.input :invoice_date, as: :datepicker, input_html: {value: Date.today}
        f.input :invoice_status, as: :select, collection: \
           InvoiceStatus.all.map { |is| [is.name, is.id] } \
           , selected: InvoiceStatus.find_by_name('New').id \
           , include_blank: :false
        f.input :term, as: :select, label: 'Terms', collection: \
           Term.all.map { |t| [t.name, t.id] } \
           , include_blank: false
        f.input :comments
      else
        f.input :description
        f.input :invoice_date, as: :datepicker
        f.input :invoice_status, as: :select, collection: \
           InvoiceStatus.all.map { |is| [is.name, is.id] } \
           , include_blank: :false
        f.input :term, as: :select, label: 'Terms', collection: \
           Term.all.map { |t| [t.name, t.id] }
        f.input :comments
      end
      f.actions
    end
  end
end
