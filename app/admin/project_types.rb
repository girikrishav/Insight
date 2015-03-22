include ActiveAdminHelper

ActiveAdmin.register ProjectType, as: "Project Type" do
  menu :if => proc { menu_accessible?(100) }, :label => "Project Types", :parent => "Lookups", :priority => 60

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to "Cancel", admin_project_types_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 100, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:billed)
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

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :billed
    column :rank
    actions
  end

  show do
    attributes_table :id, :name, :description, :billed, :rank\
        , :created_at, :updated_at, :comments
  end

  filter :name
  filter :description
  filter :rank
  filter :billed
  filter :comments
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "Project Type Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :name
      else
        f.input :name, :input_html => {:disabled => true}
      end
      f.input :description
      f.input :billed
      f.input :rank
      f.input :comments
    end
    f.actions
  end
end
