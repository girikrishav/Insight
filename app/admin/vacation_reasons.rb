include ActiveAdminHelper

ActiveAdmin.register VacationReason, as: I18n.t('active_admin.vacation_reason') do
  menu :if => proc { menu_accessible?(75) }, :label => I18n.t('active_admin.vacation_reason').pluralize\
    , :parent => I18n.t('active_admin.master').pluralize, :priority => 50

  config.sort_order = 'name_asc'

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_vacation_reasons_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 75, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:paid)
      end_of_association_chain.includes(:business_unit)
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

  show do |vr|
    panel I18n.t('active_admin.vacation_reason') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for vr do
        row :id
        row :business_unit
        row :name
        row :description
        row :paid
        row :days_allowed do
          number_with_precision vr.days_allowed, precision: 1, delimiter: ','
        end
      end
    end
  end

  filter :business_unit
  filter :name
  filter :description
  filter :paid
  filter :days_allowed
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :business_unit
    column :name
    column :description
    column :paid
    column I18n.t('active_admin.days_allowed'), :days_allowed, :sortable => 'days_allowed' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.days_allowed, :precision => 1, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.vacation_reason') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" || params[:action] == "create"
        f.input :business_unit
        f.input :name
      else
        f.input :business_unit
        f.input :name, :input_html => {:disabled => true}
      end
      f.input :description
      f.input :paid
      f.input :days_allowed
      f.input :comments
    end
    f.actions
  end
end
