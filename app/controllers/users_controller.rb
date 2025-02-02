# frozen_string_literal: true

# This controller manages the users in the family tree.
class UsersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!, except: :change_unidentified

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.csv do
        authorize User
        send_data User.to_csv(@users), filename: "users-#{Date.today}.csv"
      end
    end
  end

  def roles
    @roles = Role.order(:id).pluck(:name)
    @pagy, @users = pagy(User.where.not(id: 1).includes(:roles).order(:name), items: 10)
    authorize @users
  end

  def role_update
    @user = User.find(params[:id])
    authorize @user
    @user.roles = []
    @user.add_role(user_params[:role])
    redirect_to roles_users_path
  end

  def change
    current_user.send("#{params[:locale]}!")
    redirect_to request.referer
  end

  def change_unidentified
    session[:locale] = params[:locale]
    redirect_to request.referer
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
