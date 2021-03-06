include ActiveAdminHelper

ActiveAdmin.register ServiceRate, as: I18n.t('active_admin.service_rate') do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('active_admin.service_rate').pluralize\
  , :parent => I18n.t('active_admin.master').pluralize, :priority => 100

  config.sort_order = 'as_on_desc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_service_rates_path
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
    panel I18n.t('active_admin.service_rate') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for sr do
        row :id
        row :business_unit
        row :skill
        row :designation
        row :as_on
        row "In" do |sr|
          sr.bu_currency
        end
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
    column I18n.t('active_admin.bu'), :business_unit
    column :skill
    column :designation
    column :as_on
    column I18n.t('active_admin.in'), :bu_currency, sortable: false
    column I18n.t('active_admin.billing'), :billing_rate, :sortable => 'billing_rate' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.billing_rate, :precision => 2, delimiter: ','
      end
    end
    column I18n.t('active_admin.cost'), :cost_rate, :sortable => 'cost_rate' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.cost_rate, :precision => 2, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.service_rate') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" || params[:action] == "create"
        f.input :business_unit, :label => I18n.t('active_admin.bu')\
          , :as => :select, :collection => BusinessUnit.all \
          .map { |bu| ["#{bu.name}" + " [In = #{bu.bu_currency}]", bu.id] }
        f.input :skill
        f.input :designation
        f.input :as_on, as: :datepicker, :input_html => {:value => Date.today}
      else
        f.input :business_unit, :label => I18n.t('active_admin.bu'), :input_html => {:disabled => true}
        f.input :skill, :input_html => {:disabled => true}
        f.input :designation, :input_html => {:disabled => true}
        f.input :as_on, :input_html => {:disabled => true}
      end
      if params[:action] != "new" && params[:action] != "create"
        f.input :bu_currency, :label => I18n.t('active_admin.in'), :input_html => {:disabled => true}
      end
      f.input :billing_rate, :label => I18n.t('active_admin.billing')
      f.input :cost_rate, :label => I18n.t('active_admin.cost')
      f.input :comments
    end
    f.actions
  end
end
