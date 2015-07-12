include ActiveAdminHelper

ActiveAdmin.register Client, as: I18n.t('active_admin.client') do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('active_admin.client').pluralize\
  , :parent => I18n.t('active_admin.operation').pluralize, :priority => 30

  config.sort_order = 'name_asc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_clients_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def new
      session[:from_path] = params[:from_path]
      new!
    end

    # To redirect create and update actions redirect to index page upon submit.
    def create
      super do |format|
        @from_path = session[:from_path]
        if @from_path.nil?
          @from_path = "collection_url"
        end
        redirect_to send(@from_path) and return if resource.valid?
      end
    end

    def update
      super do |format|
        @from_path = session[:from_path]
        if @from_path.nil?
          @from_path = "collection_url"
        end
        redirect_to send(@from_path) and return if resource.valid?
      end
    end
  end

  show do
    attributes_table :id, :name, :address, :contact_name, :email, :phone, :fax\
        , :created_at, :updated_at, :comments
  end

  filter :name
  filter :address
  filter :contact_name
  filter :email
  filter :phone
  filter :fax
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :name
    column :address
    column :contact_name
    column :email
    column :phone
    column :fax
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.client') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" || params[:action] == "create"
        f.input :name
      else
        f.input :name, :input_html => {:disabled => true}
      end
      f.input :address
      f.input :contact_name
      f.input :email
      f.input :phone
      f.input :fax
      f.input :comments
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_clients_path)
    end
  end
end
