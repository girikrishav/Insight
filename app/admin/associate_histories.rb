include ActiveAdminHelper

ActiveAdmin.register AssociateHistory, as: "Associate History" do
  menu false

  config.sort_order = 'created_at_desc'

  config.clear_action_items!

  # config.batch_actions = false

  action_item only: [:index] do
    link_to "Cancel", admin_associates_path
  end

  action_item only: [:show] do
    link_to "Cancel", admin_associate_histories_path(associate_id: params[:associate_id])
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:associate)
      end_of_association_chain.includes(:associate_type)
      end_of_association_chain.includes(:business_unit)
      end_of_association_chain.includes(:department)
      end_of_association_chain.includes(:active)
      end_of_association_chain.includes(:manager)
      end_of_association_chain.includes(:user)
      if !params[:associate_id].nil?
        session[:associate_id] = params[:associate_id]
      end
      AssociateHistory.where('associate_id = ?', session[:associate_id])
    end
  end

  show do |p|
    panel 'Associate History Details' do
      attributes_table_for p do
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

  index do |p|
    if self.current_user_rank == self.highest_rank
      selectable_column
    end
    column :id
    column "BU", :business_unit
    column :name
    column :id_no
    column :manager do |m|
      if !m.manager_id.nil?
        Associate.find(m.manager_id).name
      end
    end
    column :active
    column '', :id do |t|
      link_to t('actions.view'), admin_associate_history_path(id: t.id, associate_id: params[:associate_id])
    end
  end
end
