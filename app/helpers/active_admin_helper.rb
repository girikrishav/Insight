module ActiveAdminHelper
  # make this method public (compulsory)
  def self.included(dsl)
    # nothing ...
  end

  # define helper methods here ...
  def menu_accessible?(required_role_rank)
    @current_user_rank = Role.find(current_admin_user.role_id).rank
    if required_role_rank > @current_user_rank
      return false
    end
    return true
  end


  def is_user_authorized?(required_role_rank, url)
    is_active?(current_admin_user.email)
    highest_rank
    logged_in_user_id
    @current_user_rank = Role.find(current_admin_user.role_id).rank
    if params[:id] == current_admin_user.id.to_s
      return true
    end
    if required_role_rank > @current_user_rank
      redirect_to root_path, :flash => {:error => t('messages.unauthorized', url: url)}
    end
  end

  def is_active?(email)
    @is_active = AdminUser.find_by_email(email).is_active
    if @is_active != UserStatus.find_by_name('Yes').id
      redirect_to destroy_admin_user_session_path
    end
  end

  def send_mail(from, to, subject, body, cc, bcc="")
    Pony.mail({
                  :to => to,
                  :cc => cc,
                  :bcc => bcc,
                  :from => from,
                  :subject => subject,
                  :body => body,
                  :via => :smtp,
                  :via_options => {
                      :address => Figaro.env.gmail_address,
                      :port => Figaro.env.gmail_port,
                      :enable_starttls_auto => true,
                      :user_name => Figaro.env.gmail_username,
                      :password => Figaro.env.gmail_password,
                      :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
                      :domain => "localhost.localdomain" # the HELO domain provided by the client to the server
                  }
              })
  end

  def highest_rank
    # Order by rank to get 'Administrator' rank
    @highest_rank = Role.order('rank').last.rank
  end

  def logged_in_user_id
    @current_user_id = current_admin_user.id
  end

  def current_user_rank
    @current_user_rank = Role.find(AdminUser.find(current_admin_user.id).role_id).rank
  end
end