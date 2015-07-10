include ActiveAdminHelper

ActiveAdmin.register InvoiceAdder, as: I18n.t('active_admin.project_invoice_adder') do
  menu false

  config.sort_order = 'id_asc'

  action_item only: [:index] do
    link_to I18n.t('button_labels.cancel'), admin_project_invoices_path
  end

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_project_invoice_adders_path(project_id: params[:project_id], \
      invoice_header_id: params[:invoice_header_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:invoice_header)
      end_of_association_chain.includes(:invoice_adder_type)
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      if !params[:invoice_header_id].nil?
        session[:invoice_header_id] = params[:invoice_header_id]
      end
      InvoiceAdder.where(invoice_header_id: session[:invoice_header_id])
    end

    def index
      if !params[:invoice_header_id].nil?
        session[:invoice_header_id] = params[:invoice_header_id]
      end
      @invoice_title = t('labels.invoice_adder_index_page'\
          , invoice_title: InvoiceHeader.find(session[:invoice_header_id]).id)
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

    def adder_amount
      invoice_adder_type_id = params[:invoice_adder_type_id]
      invoice_header_id = params[:invoice_header_id]
      invoice_lines_amount = InvoiceLine.where("invoice_header_id = ? and taxable is true", invoice_header_id)\
        .sum(:amount)
      amount = (InvoiceAdderType.find(invoice_adder_type_id).rate_applicable * 1 / 100) * invoice_lines_amount
      render json: '{"amount":"' + amount.to_s + '"}'
    end
  end

  show do |ia|
    panel I18n.t('active_admin.project_invoice_adder') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for ia do
        row :id
        row :invoice_header do |ih|
          ih.invoice_header.name
        end
        row :description
        row :invoice_adder_type
        row I18n.t('active_admin.in'), :bu_currency do |ia|
          ia.bu_currency
        end
        row :amount do |ia|
          number_with_precision ia.amount, precision: 2, delimiter: ','
        end
        row :comments
      end
    end
  end

  filter :description
  filter :invoice_adder_type
  filter :amount
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |ia| @invoice_title } do
    selectable_column
    column :id
    column :invoice_header do |ih|
      div(title: ih.invoice_header.name) do
        t('labels.hover_for_details')
      end
    end
    column :description
    column :invoice_adder_type
    column I18n.t('active_admin.in'), :bu_currency
    column I18n.t('active_admin.amount'), :amount, :sortable => 'amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.amount, precision: 2, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.project_invoice_adder') + ' ' + I18n.t('active_admin.detail').pluralize do
      f.input :invoice_header, as: :select, collection: InvoiceHeader.all.map { |ih| [ih.name, ih.id] }\
          , input_html: {:disabled => true, selected: InvoiceHeader.find(session[:invoice_header_id]).id}
      f.input :description
      f.input :invoice_adder_type
      f.input :amount
      f.input :comments
      f.input :invoice_header_id, as: :hidden
      f.actions
    end
  end
end
