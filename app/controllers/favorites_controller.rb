# frozen_string_literal: true

# This controller manages user favorites functionality.
class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person

  def create
    @favorite = current_user.favorites.build(person: @person)
    authorize @favorite
    
    respond_to do |format|
      if @favorite.save
        format.json { render json: { status: 'favorited', id: @favorite.id, message: I18n.t('favorites.added') } }
        format.html { redirect_back(fallback_location: @person, notice: I18n.t('favorites.added')) }
      else
        format.json { render json: { status: 'error', message: @favorite.errors.full_messages.first } }
        format.html { redirect_back(fallback_location: @person, alert: @favorite.errors.full_messages.first) }
      end
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(person: @person)
    authorize @favorite if @favorite
    
    respond_to do |format|
      if @favorite&.destroy
        format.json { render json: { status: 'unfavorited', message: I18n.t('favorites.removed') } }
        format.html { redirect_back(fallback_location: @person, notice: I18n.t('favorites.removed')) }
      else
        format.json { render json: { status: 'error', message: I18n.t('favorites.not_found') } }
        format.html { redirect_back(fallback_location: @person, alert: I18n.t('favorites.not_found')) }
      end
    end
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
  end
end
