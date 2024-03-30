class UsersController < ApplicationController
  def roles
    @roles = Role.order(:id).pluck(:name)
    @users = User.where.not(id: 1).includes(:roles).order(:name)
  end

  def role_update
    @user = User.find(params[:id])
    @user.roles = []
    @user.add_role(user_params[:role])
    redirect_to roles_users_path
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end