include ActiveAdminHelper

ActiveAdmin.register InvoiceAdderType, as: "Invoice Adder Type" do
  menu :if => proc { menu_accessible?(50) }, :label => "Invoice Adder Types", :parent => "Masters", :priority => 70

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to "Cancel", admin_invoice_adder_types_path
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
    panel 'Invoice Adder Type Details' do
      attributes_table_for iat do
        row :id
        row :name
        row :description
        row :rank
        row :applicable_date
        row 'Rate applicable (%)' do
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
    column "Rate Applicable (%)", :rate_applicable
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Invoice Adder Type Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :name
      else
        f.input :name, :input_html => {:disabled => true}
      end
      f.input :description
      f.input :rank
      f.input :applicable_date, as: :datepicker
      f.input :rate_applicable, :label => "Rate Applicable (%)"
      f.input :comments
    end
    f.actions
  end
end
