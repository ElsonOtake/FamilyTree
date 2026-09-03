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
        record_favorite_event('favorite.create')

        format.turbo_stream do
          flash.now[:notice] = I18n.t('favorites.added')
        end

        format.html do
          redirect_back(
            fallback_location: @person,
            notice: I18n.t('favorites.added')
          )
        end
      else
        format.turbo_stream do
          flash.now[:alert] = @favorite.errors.full_messages.first
        end

        format.html do
          redirect_back(
            fallback_location: @person,
            alert: @favorite.errors.full_messages.first
          )
        end
      end
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(person: @person)
    authorize @favorite if @favorite

    respond_to do |format|
      if @favorite&.destroy
        record_favorite_event('favorite.unlink')

        format.turbo_stream do
          flash.now[:notice] = I18n.t('favorites.removed')
        end

        format.html do
          redirect_back(
            fallback_location: @person,
            notice: I18n.t('favorites.removed')
          )
        end
      else
        format.turbo_stream do
          flash.now[:alert] = I18n.t('favorites.not_found')
        end

        format.html do
          redirect_back(
            fallback_location: @person,
            alert: I18n.t('favorites.not_found')
          )
        end
      end
    end
  end

  private

  # Audit who favorited/unfavorited whom. Attributed to the acting user, scoped
  # (resource) to the favorited person. Fire-and-forget, matching locale.update.
  def record_favorite_event(name)
    current_user.events.create(name: name, resource: @person, data: { person_id: @person.id })
  end

  def set_person
    @person = Person.find(params[:person_id])
  end
end
