class UsersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!

  def roles
    @roles = Role.order(:id).pluck(:name)
    @pagy, @users = pagy(User.where.not(id: 1).includes(:roles).order(:name), items: 10)
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