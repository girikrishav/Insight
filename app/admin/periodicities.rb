ActiveAdmin.register Periodicity do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('labels.periodocities'), :parent => I18n.t('labels.lookups'), :priority => 90

  config.sort_order = 'rank_asc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_periodicities_path
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

  show do |p|
    panel I18n.t('labels.periodicity_details') do
      attributes_table_for p do
        row :id
        row :name
        row :description
        row :rank
        row :created_at
        row :updated_at
        row :comments
      end
    end
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

  form do |f|
    f.inputs I18n.t('labels.periodicity_details') do
      if params[:action] == "new" || params[:action] == "create"
        f.input :name
      else
        f.input :name, :input_html => {:disabled => true}
      end
      f.input :description
      f.input :rank
      f.input :comments
    end
    f.actions
  end
end
