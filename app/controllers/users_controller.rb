# frozen_string_literal: true

# This controller manages the users in the family tree.
class UsersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!, except: :change_unidentified
  before_action -> { authorize User }

  def index
    @users = User.all
  end

  def download
    users = User.all.order(:id)
    # users = User.with_deleted.order(:id)
    respond_to do |format|
      format.csv do
        send_data User.to_csv(users), filename: "users-#{Date.today}.csv"
      end
    end
  end

  def roles
    @roles = Role.order(:id).pluck(:name)
    @pagy, @users = pagy(User.where.not(id: 1).includes(:roles).order(:name), items: 10)
  end

  def role_update
    @user = User.find(params[:id])
    old_roles = @user.roles.pluck(:name)
    @user.roles = []
    @user.add_role(user_params[:role])
    current_user.events.create(
      name: 'role.update',
      data: { user_id: @user.id, old_roles: , new_roles: @user.roles.pluck(:name) }
    )
    redirect_to roles_users_path
  end

  def change
    locale = params[:locale]
    
    # Validate locale against allowed values
    if User.locales.keys.include?(locale)
      current_user.update!(locale: locale)
      current_user.events.create(
        name: 'locale.update',
        data: { locale: locale }
      )
      redirect_to request.referer
    else
      redirect_to request.referer, alert: I18n.t('errors.invalid_locale')
    end
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
