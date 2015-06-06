include ActiveAdminHelper

ActiveAdmin.register CostAdderType, as: "Cost Adder Type" do
  menu :if => proc { menu_accessible?(50) }, :label => "Cost Adder Types", :parent => "Masters", :priority => 80

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to "Cancel", admin_cost_adder_types_path
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

  show do
    attributes_table :id, :name, :description, :rank\
        , :created_at, :updated_at, :comments
  end

  filter :name
  filter :description
  filter :rank
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :rank
    actions dropdown: :true
  end
end
