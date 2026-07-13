# frozen_string_literal: true

# This controller manages the couples in the family tree.
class CouplesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_couple, only: %i[edit update destroy]
  before_action :set_person, only: %i[new edit create update destroy]
  before_action :set_people, only: %i[new edit]
  before_action -> { authorize Couple }

  # GET /couples or /couples.json
  def index
    @couples = Couple.includes(:person1, :person2).all
  end

  def download
    couples = Couple.with_deleted.order(:id)
    respond_to do |format|
      format.csv do
        send_data Couple.to_csv(couples), filename: "couples-#{Date.today}.csv"
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
      @couple.current_user = current_user
      if @couple.save
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
      @couple.current_user = current_user
      if @couple.update(couple_params)
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
    @couple.current_user = current_user
    @couple.destroy

    respond_to do |format|
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
