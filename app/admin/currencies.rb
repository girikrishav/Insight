include ActiveAdminHelper

ActiveAdmin.register Currency, as: I18n.t('active_admin.currency') do
  menu :if => proc { menu_accessible?(100) }, :label => I18n.t('active_admin.currency').pluralize\
  , :parent => I18n.t('active_admin.lookup').pluralize, :priority => 70

  config.sort_order = 'name_asc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_currencies_path
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
    attributes_table :id, :name, :description, :created_at, :updated_at, :comments
  end

  filter :name
  filter :description
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :name
    column :description
    actions dropdown: :true
  end
end
