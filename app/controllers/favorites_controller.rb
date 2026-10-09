# This controller manages user favorites functionality.
class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person

  def create
    @favorite = current_user.favorites.build(person: @person)
    authorize @favorite

    if @favorite.save
      record_favorite_event('favorite.create')
      respond_with_notice(I18n.t('favorites.added'))
    else
      respond_with_alert(@favorite.errors.full_messages.first, render_template: :create_error)
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(person: @person)
    authorize @favorite if @favorite

    if @favorite&.destroy
      record_favorite_event('favorite.unlink')
      respond_with_notice(I18n.t('favorites.removed'))
    else
      respond_with_alert(I18n.t('favorites.not_found'))
    end
  end

  private

  def respond_with_notice(message)
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = message }
      format.html { redirect_back(fallback_location: @person, notice: message) }
    end
  end

  def respond_with_alert(message, render_template: nil)
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = message
        render render_template if render_template
      end
      format.html { redirect_back(fallback_location: @person, alert: message) }
    end
  end

  # Audit who favorited/unfavorited whom. Attributed to the acting user, scoped
  # (resource) to the favorited person. Fire-and-forget, matching locale.update.
  def record_favorite_event(name)
    current_user.events.create(name: name, resource: @person, data: { person_id: @person.id })
  end

  def set_person
    @person = Person.find(params[:person_id])
  end
end
