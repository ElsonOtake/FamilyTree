# frozen_string_literal: true

# This controller manages the couples in the family tree.
class CouplesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_couple, only: %i[show edit update destroy]
  before_action :set_person, only: %i[new edit create update]
  before_action :set_people, only: %i[new edit]
  before_action -> { authorize Couple }

  # GET /couples or /couples.json
  def index
    @couples = Couple.all
  end

  def download
    @couples = Couple.all
    respond_to do |format|
      format.csv do
        send_data Couple.to_csv(Couple.with_deleted.order(:id)), filename: "couples-#{Date.today}.csv"
      end
    end
  end

  # GET /couples/new
  def new
    @couple = Couple.new
    @couple.person1_id = @person.id
  end

  # GET /couples/1/edit
  def edit; end

  # POST /couples or /couples.json
  def create
    @couple = Couple.new(couple_params)

    respond_to do |format|
      if @couple.save
        FamilyMailer.with(user: current_user, couple: @couple).couple_created.deliver_later
        @mate = @couple.person1_id == @person.id ? Person.find(@couple.person2_id) : Person.find(@couple.person1_id)
        format.html { redirect_to person_url(@person) }
        format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('couples.form.couple')) }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash.now[:notice] = @couple.errors.full_messages[0]
        format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
      end
    end
  end

  # PATCH/PUT /couples/1 or /couples/1.json
  def update
    respond_to do |format|
      if @couple.update(couple_params)
        FamilyMailer.with(user: current_user, couple: @couple).couple_updated.deliver_later
        format.html { redirect_to person_url(@person) }
        format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.updated', model: I18n.t('couples.form.couple')) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        flash.now[:notice] = @couple.errors.full_messages[0]
        format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
      end
    end
  end

  # DELETE /couples/1 or /couples/1.json
  def destroy
    id = @couple.id
    person_1 = @couple.person1_id
    person_2 = @couple.person2_id
    marriage = @couple.marriage
    separation = @couple.separation
    local = @couple.local
    @couple.destroy

    respond_to do |format|
      FamilyMailer.with(user: current_user, id:, person_1:, person_2:, marriage:, separation:, local:).couple_deleted.deliver_later
      format.html { redirect_to person_url(@person) }
      format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.unlinked', model: I18n.t('couples.form.couple')) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_couple
    @couple = Couple.find(params[:id])
  end

  def set_people
    session[:gender] = @person.gender
    session[:id] = @person.id
    @q = Person.ransack(params[:q])
    @people = []
  end

  # Only allow a list of trusted parameters through.
  def couple_params
    params.require(:couple).permit(:person1_id, :person2_id, :marriage, :separation, :local)
  end
end
