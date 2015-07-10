include ActiveAdminHelper

ActiveAdmin.register Skill, as: I18n.t('active_admin.skill') do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('active_admin.skill').pluralize\
    , :parent => I18n.t('active_admin.master').pluralize, :priority => 40

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_skills_path
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
