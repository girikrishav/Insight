include ActiveAdminHelper

ActiveAdmin.register InvoiceLine, as: "Invoice Line" do
  menu false

  config.sort_order = 'id_asc'

  action_item only: [:index] do
    link_to "Cancel", admin_invoice_headers_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_invoice_lines_path(project_id: params[:project_id], \
      invoice_header_id: params[:invoice_header_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:invoice_header)
      end_of_association_chain.includes(:invoicing_milestone)
      if !params[:project_id].nil?
        session[:project_id] = params[:project_id]
      end
      if !params[:invoice_header_id].nil?
        session[:invoice_header_id] = params[:invoice_header_id]
      end
      InvoiceLine.where(invoice_header_id: session[:invoice_header_id])
    end

    def index
      if !params[:invoice_header_id].nil?
        session[:invoice_header_id] = params[:invoice_header_id]
      end
      @invoice_title = t('labels.invoice_line_index_page'\
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
  end

  show do |ia|
    panel 'Invoice Line Details' do
      attributes_table_for ia do
        row :id
        row :invoice_header do |ih|
          ih.invoice_header.complete_name
        end
        row :description
        row :invoicing_milestone
        row :amount do |il|
          number_with_precision il.amount, precision: 0, delimiter: ','
        end
        row :taxable
        row :comments
      end
    end
  end

  filter :description
  filter :invoicing_milestone
  filter :amount
  filter :taxable
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |ia| @invoice_title } do
    selectable_column
    column :id
    column :invoice_header do |ih|
      div(title: ih.invoice_header.complete_name) do
        t('labels.hover_for_details')
      end
    end
    column :description
    column :invoicing_milestone
    column 'Amount', :amount, :sortable => 'amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.amount, precision: 0, delimiter: ','
      end
    end
    column :taxable
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Invoice Line Details" do
      f.input :invoice_header, as: :select, collection: InvoiceHeader.all.map { |ih| [ih.complete_name, ih.id] }\
          , input_html: {:disabled => true, selected: InvoiceHeader.find(session[:invoice_header_id]).id}
      f.input :description
      f.input :invoicing_milestone
      f.input :amount
      f.input :taxable, as: :select, include_blank: false
      f.input :comments
      f.actions
    end
  end
end
