include ActiveAdminHelper

ActiveAdmin.register Holiday, as: "Holiday" do
  menu :if => proc { menu_accessible?(50) }, :label => "Holidays", :parent => "Masters", :priority => 60

  config.sort_order = 'as_on_desc'

  action_item only: [:show] do
    link_to "Cancel", admin_holidays_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:business_unit)
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

  show do
    attributes_table :id, :business_unit, :name, :as_on, :description\
        , :created_at, :updated_at, :comments
  end

  filter :business_unit
  filter :name
  filter :as_on
  filter :description
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :business_unit
    column :as_on
    column :name
    column :description
    actions
  end

  scope :all_by_business_unit do |holidays|
    holidays.where("1 = 1").reorder('business_unit_id ASC, as_on DESC, name ASC')
  end

  scope :active_by_business_unit do |holidays|
    holidays.where("as_on >= ?", Date.today).reorder('business_unit_id ASC, as_on DESC, name ASC')
  end

  scope :inactive_by_business_unit do |holidays|
    holidays.where("as_on < ?", Date.today).reorder('business_unit_id ASC, as_on DESC, name ASC')
  end

  form do |f|
    f.inputs "Holiday Details" do
    if params[:action] == "new" || params[:action] == "create"
      f.input :business_unit
      f.input :name
      f.input :as_on, as: :datepicker
    else
        f.input :business_unit, :input_html => {:disabled => true}
        f.input :name, :input_html => {:disabled => true}
        f.input :as_on, :input_html => {:disabled => true}
      end
      f.input :description
      f.input :comments
    end
    f.actions
  end
end
