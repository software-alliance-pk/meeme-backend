module UsersHelper
  def update_status(user)
    user.update(status: false)
  end
end
