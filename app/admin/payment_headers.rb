include ActiveAdminHelper

ActiveAdmin.register PaymentHeader, as: I18n.t('active_admin.payment') do
  menu :if => proc { menu_accessible?(25) }, :label => I18n.t('active_admin.payment').pluralize\
  , :parent => I18n.t('active_admin.operation').pluralize, :priority => 80

  config.sort_order = 'payment_date_desc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_payments_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 25, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:payment_status)
      end_of_association_chain.includes(:currency)
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

  show do |ph|
    panel I18n.t('active_admin.payment') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for ph do
        row :id
        row :description
        row :payment_date
        row I18n.t('active_admin.in') do |ph|
          ph.currency
        end
        row :amount do |ph|
          number_with_precision ph.amount, precision: 0, delimiter: ','
        end
        row :unapplied do |ph|
          number_with_precision ph.unapplied, precision: 0, delimiter: ','
        end
        row :payment_status
        row :comments
      end
    end
  end

  filter :description
  filter :payment_date
  filter :currency
  filter :amount
  filter :unapplied
  filter :payment_status
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :description
    column :payment_date
    column I18n.t('active_admin.in'), :currency
    column I18n.t('active_admin.amount'), :amount, :sortable => 'amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.amount, precision: 2, delimiter: ','
      end
    end
    column I18n.t('active_admin.unapplied'), :unapplied, :sortable => 'unapplied' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.unapplied, precision: 2, delimiter: ','
      end
    end
    column :payment_status
    actions dropdown: :true do |ph|
      item I18n.t('active_admin.payment_line'), admin_payment_lines_path(payment_header_id: ph.id)
    end
  end

  form do |f|
    f.inputs I18n.t('active_admin.payment') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" or params[:action] == "create"
        f.input :description
        f.input :payment_date, as: :datepicker, input_html: {value: Date.today}
        f.input :currency
        f.input :amount
        f.input :payment_status, as: :select, collection: \
           PaymentStatus.all.map { |ps| [ps.name, ps.id] } \
           , selected: PaymentStatus.find_by_name('New').id \
           , include_blank: :false
        f.input :comments
      else
        f.input :description, input_html: {:disabled => true}
        f.input :payment_date, as: :datepicker, input_html: {:disabled => true}
        f.input :currency, input_html: {:disabled => true}
        f.input :amount, input_html: {:disabled => true}
        f.input :payment_status, input_html: {:disabled => true}
        f.input :comments
      end
      f.actions
    end
  end
end
