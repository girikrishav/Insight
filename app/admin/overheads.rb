include ActiveAdminHelper

ActiveAdmin.register Overhead, as: "Overhead" do
  menu :if => proc { menu_accessible?(65) }, :label => "Overheads", :parent => "Operations", :priority => 20

  config.sort_order = 'as_on_desc'

  action_item only: [:show] do
    link_to "Cancel", admin_overheads_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 65, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:business_unit)
      end_of_association_chain.includes(:cost_adder_type)
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

  show do |o|
    panel 'Overhead Details' do
      attributes_table_for o do
        row :id
        row :business_unit
        row :cost_adder_type
        row :as_on
        row :bu_currency
        row :amount do
          number_with_precision o.amount, precision: 2, delimiter: ','
        end
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :business_unit
  filter :cost_adder_type
  filter :as_on
  filter :amount
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :business_unit
    column :cost_adder_type
    column :as_on
    column "Currency", :bu_currency, sortable: false
    column "Amount", :amount, :sortable => 'amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.amount, :precision => 2, delimiter: ','
      end
    end
    actions
  end

  form do |f|
    f.inputs "Overhead Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :business_unit, as: :select, collection: BusinessUnit.all\
          .map { |fs| [fs.name_with_currency, fs.id] }
        f.input :cost_adder_type
        f.input :as_on, as: :datepicker, :input_html => {:value => Date.today}
      else
        f.input :business_unit, :input_html => {:disabled => true}
        f.input :cost_adder_type, :input_html => {:disabled => true}
        f.input :as_on, :input_html => {:disabled => true}
      end
      if params[:action] != "new" && params[:action] != "create"
        f.input :bu_currency, :label => 'Currency', :input_html => {:disabled => true}
      end
      f.input :amount
      f.input :comments
    end
    f.actions
  end
end
