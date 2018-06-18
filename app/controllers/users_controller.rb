class UsersController < ApplicationController
  def create
    @user = User.create!(users_params)
    json_response({message: "user successfully created", user_id: @user.id})
  end

  private
    
  def users_params
    params.require(:user).permit(:email)
  end
end
