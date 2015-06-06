include ActiveAdminHelper

ActiveAdmin.register BusinessUnit, as: "Business Unit" do
  menu :if => proc { menu_accessible?(75) }, :label => "Business Units", :parent => "Masters", :priority => 10

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to "Cancel", admin_business_units_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 75, url_for)
    end

    def scoped_collection
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

  show do
    attributes_table :id, :name, :description, :rank, :currency\
        , :created_at, :updated_at, :comments
  end

  filter :name
  filter :description
  filter :currency
  filter :rank
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :currency
    column :rank
    column :comments
    actions dropdown: :true
  end

  form do |f|
    f.inputs "Business Unit Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :name
      else
        f.input :name, :input_html => {:disabled => true}
      end
      f.input :description
      f.input :currency
      f.input :rank
      f.input :comments
    end
    f.actions
  end
end
