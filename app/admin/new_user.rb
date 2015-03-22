include ActiveAdminHelper

ActiveAdmin.register_page "Add User" do
  # menu :if => proc {menu_accessible?(60)}, :parent => "Security", :priority => 60
  menu false

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 60, url_for)
      redirect_to new_admin_user_path
    end
  end

  content do
  end
end