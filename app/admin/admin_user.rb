include ActiveAdminHelper

ActiveAdmin.register AdminUser, :as => I18n.t('active_admin.user') do
  menu :if => proc { menu_accessible?(60) }, :parent => "Security", :priority => 40

  config.sort_order = 'email_asc'

  config.clear_action_items!

  action_item only: [:show] do
    link_to t('button_labels.cancel'), admin_users_path
  end

  batch_action :activate do |ids|
    AdminUser.find(ids).each do |au|
      if au.email != current_admin_user.email
        au.is_active = UserStatus.find_by_name('Yes').id
        au.password = "password"
        au.password_confirmation = "password"
        au.save
      end
    end
    redirect_to collection_path, alert: I18n.t('messages.users_activated')
  end

  batch_action :deactivate do |ids|
    AdminUser.find(ids).each do |au|
      if au.email != current_admin_user.email
        au.is_active = UserStatus.find_by_name('No').id
        au.password = "password"
        au.password_confirmation = "password"
        au.save
      end
    end
    redirect_to collection_path, alert: I18n.t('messages.users_deactivated')
  end

  action_item only: [:index] do
    link_to t('button_labels.new_user'), new_admin_user_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 60, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:active)
      AdminUser.where(id: AdminUser.allowed_ids(@current_user_rank, @current_user_id))
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
    attributes_table :id, :email, :sign_in_count, :current_sign_in_at, :last_sign_in_at\
        , :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :is_active
  end

  filter :email
  filter :role
  filter :active
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :email
    column I18n.t('active_admin.current_sign_in'), :current_sign_in_at
    column I18n.t('active_admin.logins'), :sign_in_count
    column :role
    column :active
    actions dropdown: :true
  end

  filter :email
  filter :role, :as => :select, :collection => \
    proc { Role.allowed(@current_user_rank).map { |r| ["#{r.name}", r.id] } }
  filter :active

  # Form begins.
  form do |f|
    f.inputs I18n.t('active_admin.user') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" || params[:action] == "create"
        f.input :email
      else
        f.input :email, :input_html => {:disabled => true}
      end
      f.input :password
      f.input :password_confirmation
      if (params[:action] != "new" && params[:action] != "create") && params[:id] == current_admin_user.id.to_s
        f.input :role_id, :label => 'Role' \
          , :as => :select, :collection => Role.allowed(self.current_user_rank) \
          .map { |r| ["#{r.name}", r.id] }, :input_html => {:disabled => true}
      else
        f.input :role_id, :label => 'Role' \
          , :as => :select, :collection => Role.allowed(self.current_user_rank) \
          .map { |r| ["#{r.name}", r.id] }
      end
      if params[:action] == "new" || params[:action] == "create"
        f.input :is_active, :label => 'Active', as: :select, collection: UserStatus.all.map { |r| ["#{r.name}", r.id] }, include_blank: false
      else
        f.input :is_active, :label => 'Active', as: :select, collection: UserStatus.all.map { |r| ["#{r.name}", r.id] }, include_blank: false, :input_html => {:disabled => true}
      end
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(root_path)
    end
  end
end                                   
