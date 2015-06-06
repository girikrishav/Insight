include ActiveAdminHelper

ActiveAdmin.register ServiceRate, as: "Service Rate" do
  menu :if => proc { menu_accessible?(50) }, :label => "Service Rates", :parent => "Masters", :priority => 100

  config.sort_order = 'as_on_desc'

  action_item only: [:show] do
    link_to "Cancel", admin_service_rates_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:business_unit)
      end_of_association_chain.includes(:skill)
      end_of_association_chain.includes(:designation)
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

  show do |sr|
    panel 'Service Rate Details' do
      attributes_table_for sr do
        row :id
        row :business_unit
        row :skill
        row :designation
        row :as_on
        row :bu_currency
        row :billing_rate do
          number_with_precision sr.billing_rate, precision: 2, delimiter: ','
        end
        row :cost_rate do
          number_with_precision sr.cost_rate, precision: 2, delimiter: ','
        end
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :business_unit
  filter :skill
  filter :designation
  filter :as_on
  filter :billing_rate
  filter :cost_rate
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column 'BU', :business_unit
    column :skill
    column :designation
    column :as_on
    column "Currency", :bu_currency, sortable: false
    column "Billing", :billing_rate, :sortable => 'billing_rate' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.billing_rate, :precision => 2, delimiter: ','
      end
    end
    column "Cost", :cost_rate, :sortable => 'cost_rate' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.cost_rate, :precision => 2, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Service Rate Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :business_unit, :label => 'BU'\
          , :as => :select, :collection => BusinessUnit.all \
          .map { |bu| ["#{bu.name}" + " [Currency = #{bu.bu_currency}]", bu.id] }
        f.input :skill
        f.input :designation
        f.input :as_on, as: :datepicker, :input_html => {:value => Date.today}
      else
        f.input :business_unit, :label => 'BU', :input_html => {:disabled => true}
        f.input :skill, :input_html => {:disabled => true}
        f.input :designation, :input_html => {:disabled => true}
        f.input :as_on, :input_html => {:disabled => true}
      end
      if params[:action] != "new" && params[:action] != "create"
        f.input :bu_currency, :label => 'Currency', :input_html => {:disabled => true}
      end
      f.input :billing_rate, :label => 'Billing'
      f.input :cost_rate, :label => 'Cost'
      f.input :comments
    end
    f.actions
  end
end
