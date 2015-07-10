include ActiveAdminHelper

ActiveAdmin.register Term, as: I18n.t('active_admin.term') do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('active_admin.term').pluralize\
    , :parent => I18n.t('active_admin.master').pluralize, :priority => 110

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_terms_path
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
    attributes_table :id, :name, :description, :days\
        , :rank, :created_at, :updated_at, :comments
  end

  filter :name
  filter :description
  filter :days
  filter :rank
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :days
    column :rank
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.term') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" || params[:action] == "create"
        f.input :name
        f.input :description
        f.input :days
        f.input :rank
        f.input :comments
      else
        f.input :name, :input_html => {:disabled => true}
        f.input :description
        f.input :days, :input_html => {:disabled => true}
        f.input :rank
        f.input :comments
      end
    end
    f.actions
  end
end
