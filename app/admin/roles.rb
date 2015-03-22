include ActiveAdminHelper

ActiveAdmin.register Role do
  menu :if => proc { menu_accessible?(100) }, :parent => "Security", :priority => 30

  config.sort_order = 'rank_desc'

  action_item only: [:show] do
    link_to "Cancel", admin_roles_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 100, url_for)
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
    attributes_table :id, :name, :rank, :created_at, :updated_at
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
    column :rank
    actions
  end
end
