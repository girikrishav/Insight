include ActiveAdminHelper

ActiveAdmin.register AssociateServiceRate, as: "Associate Service Rate" do
  menu false

  config.sort_order = 'as_on_desc'

  action_item only: [:index] do
    link_to "Cancel", admin_associates_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_associate_service_rates_path(associate_id: params[:associate_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:associate)
      end_of_association_chain.includes(:service_rate)
      if !params[:associate_id].nil?
        session[:associate_id] = params[:associate_id]
      end
      AssociateServiceRate.where(associate_id: session[:associate_id])
    end

    def index
      if !params[:associate_id].nil?
        session[:associate_id] = params[:associate_id]
      end
      @associate_service_rate_title = t('labels.associate_service_rate_index_page'\
          , associate_title: Associate.find(session[:associate_id]).id)
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

  show do |sr|
    panel 'Associate Service Rate Details' do
      attributes_table_for sr do
        row :id
        row :associate
        row :service_rate do
          sr.service_rate.skill_designation
        end
        row :as_on
        row "In" do |asr|
          asr.bu_currency
        end
        row :billing_rate do
          number_with_precision sr.billing_rate, precision: 2, delimiter: ','
        end
        row :cost_rate do
          number_with_precision sr.cost_rate, precision: 2, delimiter: ','
        end
        row :comments
      end
    end
  end

  filter :associate, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :service_rate, :as => :select, :collection => \
      proc { ServiceRate.all.map { |au| ["#{au.skill_designation}", au.id] } }
  filter :as_on
  filter :billing_rate
  filter :cost_rate
  filter :comments
  filter :created_at
  filter :updated_at

  index title: proc { |p| @associate_service_rate_title } do
    selectable_column
    column :id
    column :associate
    column "Skill", :skill_name
    column "Designation", :designation_name
    column :as_on
    column "In", :bu_currency
    column t('labels.billing_rate'), :billing_rate, :sortable => 'billing_rate' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.billing_rate, precision: 2, delimiter: ','
      end
    end
    column t('labels.cost_rate'), :cost_rate, :sortable => 'cost_rate' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.cost_rate, precision: 2, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Associate Service Rate Details" do
      f.input :associate, input_html: {:disabled => true}

      if params[:action] == "new" || params[:action] == "create"
        f.input :service_rate, label: 'Skill Designation', as: :select, collection: ServiceRate.all\
          .map { |p| [p.skill_designation, p.id] }
        f.input :as_on, as: :datepicker, input_html: {value: Date.today}
      else
        f.input :service_rate, label: 'Skill Designation', as: :select, collection: ServiceRate.all\
          .map { |p| [p.skill_designation, p.id] }, input_html: {:disabled => true}
        f.input :as_on, as: :datepicker
        f.input :bu_currency, input_html: {:disabled => true}
        f.input :billing_rate
        f.input :cost_rate
      end
      f.input :comments
      f.actions
    end
  end
end