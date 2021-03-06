include ActiveAdminHelper

ActiveAdmin.register_page I18n.t('active_admin.edit_profile') do
  menu :if => proc {menu_accessible?(1)}, :parent => I18n.t('active_admin.security'), :priority => 20

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 1, url_for)
      redirect_to edit_admin_user_path(:id => current_admin_user.id)
    end
  end

  content do
  end
end