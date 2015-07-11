include ActiveAdminHelper

ActiveAdmin.register InvoiceAdderType, as: I18n.t('active_admin.invoice_adder_type') do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('active_admin.invoice_adder_type').pluralize\
  , :parent => I18n.t('active_admin.master').pluralize, :priority => 70

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_invoice_adder_types_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
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

  show do |iat|
    panel I18n.t('active_admin.invoice_adder_type') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for iat do
        row :id
        row :name
        row :description
        row :rank
        row :applicable_date
        row I18n.t('active_admin.rate_applicable_percent') do
          iat.rate_applicable
        end
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :name
  filter :description
  filter :rank
  filter :applicable_date
  filter :rate_applicable
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :rank
    column :applicable_date
    column I18n.t('active_admin.rate_applicable_percent'), :rate_applicable
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.invoice_adder_type') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" || params[:action] == "create"
        f.input :name
      else
        f.input :name, :input_html => {:disabled => true}
      end
      f.input :description
      f.input :rank
      f.input :applicable_date, as: :datepicker
      f.input :rate_applicable, :label => I18n.t('active_admin.rate_applicable_percent')
      f.input :comments
    end
    f.actions
  end
end
