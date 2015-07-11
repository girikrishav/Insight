include ActiveAdminHelper

ActiveAdmin.register Associate, as: I18n.t('active_admin.associate') do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('active_admin.associate').pluralize\
  , :parent => I18n.t('active_admin.operation').pluralize, :priority => 10

  config.sort_order = 'name_asc'

  config.paginate = false

  action_item only: [:new] do
    link_to t('button_labels.new_user'), new_admin_user_path(from_path: 'new_admin_associate_path')
  end

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_associates_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:active)
      end_of_association_chain.includes(:manager)
      end_of_association_chain.includes(:user)
      end_of_association_chain.includes(:department)
      end_of_association_chain.includes(:business_unit)
      end_of_association_chain.includes(:associate_type)
      Associate.where(user_id: AdminUser.allowed_ids(@current_user_rank, @current_user_id))
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

  def current_user_rank
    @current_user_rank
  end

  def current_user_id
    @current_user_id
  end

  show do |a|
    panel I18n.t('active_admin.associate') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for a do
        row :id
        row :name
        row :as_on
        row :id_no
        row :doj
        row :dol
        row :user
        row :manager
        row :department
        row :business_unit
        row :active
        row :associate_type
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :name
  filter :as_on
  filter :id_no
  filter :doj
  filter :dol
  filter :user, :as => :select, :collection => \
      proc { AdminUser.allowed(@current_user_rank, @current_user_id)\
      .map { |au| ["#{au.email}", au.id] } }
  filter :manager, :as => :select, :collection => \
      proc { Associate.order('name ASC').map { |au| ["#{au.name}", au.id] } }
  filter :department
  filter :business_unit
  filter :active
  filter :associate_type
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column I18n.t('active_admin.id'), sortable: :id do |t|
      div(title: t('labels.associate_histories')) do
        if AssociateHistory.where(associate_id: t.id).count > 0
          link_to t.id, admin_associate_histories_path(associate_id: t.id)
        else
          t.id
        end
      end
    end
    column I18n.t('active_admin.bu'), sortable: :business_unit do |t|
      div(title: t('labels.associate_service_rates')) do
        link_to t.business_unit.name, admin_associate_service_rates_path(associate_id: t.id)
      end
    end
    column I18n.t('active_admin.name'), sortable: :name do |t|
      div(title: t('labels.assignment_allocations')) do
        link_to t.name, admin_assignment_allocations_path(associate_id: t.id)
      end
    end
    column I18n.t('active_admin.user'), :user do |t|
      t.user.email
    end
    column :id_no
    column :manager do |m|
      if !m.manager_id.nil?
        Associate.find(m.manager_id).name
      end
    end
    column :active
    actions dropdown: :true
  end

  form do |f|
    f.inputs I18n.t('active_admin.associate') + ' ' + I18n.t('active_admin.detail').pluralize do
      f.input :business_unit, :label => I18n.t('active_admin.bu')
      f.input :name
      f.input :user, :label => I18n.t('active_admin.user') \
        , :as => :select, :collection => AdminUser.allowed(self.current_user_rank \
        , self.current_user_id).map { |au| ["#{au.email}", au.id] }
      if params[:action] == "new" or params[:action] == "create"
        f.input :as_on, as: :datepicker, :input_html => {:value => Date.today}
      else
        f.input :as_on, as: :datepicker
      end
      f.input :id_no
      f.input :associate_type, :label => I18n.t('active_admin.type'), as: :select, collection: AssociateType.all.map \
        { |r| ["#{r.name}", r.id] }, include_blank: false
      if params[:action] == "new" or params[:action] == "create"
        f.input :doj, :label => I18n.t('active_admin.date_of_joining'), as: :datepicker, :input_html => {:value => Date.today}
      else
        f.input :doj, :label => I18n.t('active_admin.date_of_joining'), as: :datepicker
      end
      f.input :dol, :label => I18n.t('active_admin.date_of_leaving'), as: :datepicker
      f.input :active, as: :select, collection: FlagStatus.all.map \
        { |r| ["#{r.name}", r.id] }, include_blank: false
      f.input :manager
      f.input :department
      f.input :comments
    end
    f.actions
  end
end
