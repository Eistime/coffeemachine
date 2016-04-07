class UsersController

  def initialize users_model
    @users_model = users_model
  end

  def get_users
    {users: @users_model.get_list}
  end

  def get_users_edit params
    @users_model.get params['id']
  end

  def post_users_edit params
    @users_model.edit(params['id'], params['password'])
  end

  def post_users_delete params
    @users_model.delete params['id']
  end

  def get_users_new
    view_locals = {:user_duplicated => false, :user_created => false}
  end

  def post_users_new params
    success = @users_model.create(params['username'], params['password'])
    view_locals = {:user_duplicated => !success, :user_created => success}
  end

end
