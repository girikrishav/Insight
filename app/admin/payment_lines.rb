include ActiveAdminHelper

ActiveAdmin.register PaymentLine, as: "Payment Line" do
  menu false

  config.sort_order = 'id_asc'

  action_item only: [:index] do
    link_to "Cancel", admin_payments_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_payment_lines_path(payment_header_id: params[:payment_header_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:payment_header)
      end_of_association_chain.includes(:invoice_header)
      if !params[:payment_header_id].nil?
        session[:payment_header_id] = params[:payment_header_id]
      end
      PaymentLine.where(payment_header_id: session[:payment_header_id])
    end

    def index
      if !params[:payment_header_id].nil?
        session[:payment_header_id] = params[:payment_header_id]
      end
      @payment_title = t('labels.payment_line_index_page'\
          , payment_title: PaymentHeader.find(session[:payment_header_id]).id)
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

  show do |pl|
    panel 'Payment Line Details' do
      attributes_table_for pl do
        row :id
        row :payment_header do |ph|
          ph.payment_header.complete_name
        end
        row :description
        row :invoice_header do |ih|
          ih.invoice_header.complete_name
        end
        row :amount do |il|
          number_with_precision il.amount, precision: 2, delimiter: ','
        end
        row :comments
      end
    end
  end

  filter :description
  filter :invoice_header
  filter :amount
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |pl| @payment_title } do
    selectable_column
    column :id
    column :payment_header do |ph|
      div(title: ph.payment_header.complete_name) do
        t('labels.hover_for_details')
      end
    end
    column :description
    column :invoice_header do |ih|
      div(title: ih.invoice_header.complete_name) do
        t('labels.hover_for_details')
      end
    end
    column 'Amount', :amount, :sortable => 'amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.amount, precision: 2, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Payment Line Details" do
      f.input :payment_header, as: :select, collection: PaymentHeader.all.map { |ph| [ph.complete_name, ph.id] }\
          , input_html: {:disabled => true, selected: PaymentHeader.find(session[:payment_header_id]).id}
      f.input :description
      f.input :invoice_header
      f.input :amount
      f.input :comments
      f.actions
    end
  end
end
