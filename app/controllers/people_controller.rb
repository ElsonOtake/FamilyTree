# frozen_string_literal: true

# This controller manages the people in the family tree.
class PeopleController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_person, only: %i[show edit update destroy]
  before_action -> { authorize Person }

  # GET /people or /people.json
  def index
    @q = Person.ransack(params[:q])

    # Show favorites when no search/filter is active, otherwise show search results
    if search_active?
      @pagy, @people = pagy(@q.result, items: 10)
      @showing_favorites = false
    else
      @pagy, @people = pagy(current_user.favorite_people, items: 10)
      @showing_favorites = true
    end

    # Preload favorites for the current page to avoid N+1 queries
    @favorites_lookup = current_user.favorites.where(person: @people).index_by(&:person_id)
  end

  def download
    people = Person.with_deleted.order(:id)
    respond_to do |format|
      format.csv do
        send_data Person.to_csv(people), filename: "people-#{Date.today}.csv"
      end
    end
  end

  # GET /people/1 or /people/1.json
  def show
    # Preload favorite to avoid additional query in view
    @favorite = current_user.favorites.find_by(person: @person)
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit; end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)
    @mate = nil
    @child = nil

    respond_to do |format|
      @person.current_user = current_user
      if @person.save!
        if couple_params[:mate].present?
          @couple = Couple.new(person1_id: couple_params[:mate], person2_id: @person.id, marriage: couple_params[:marriage],
                               separation: couple_params[:separation], local: couple_params[:local])
          @couple.current_user = current_user

          if @couple.save
            @mate = @person
            @person = Person.find(couple_params[:mate])
            format.html { redirect_to person_path(@person), notice: I18n.t('activerecord.success.messages.created', model: I18n.t('couples.form.couple')) }
            format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('couples.form.couple')) }
          else
            format.html { render :new, status: :unprocessable_entity }
            flash.now[:notice] = @couple.errors.full_messages[0]
            format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
          end
        elsif couple_params[:couple].present?
          @couple = Couple.find(couple_params[:couple])

          if @couple.people << @person
            Child.new(person_id: @person.id, couple_id: @couple.id).register_event(@person, @couple, current_user, 'child.create')
            @child = @person
            @person = Person.find(@couple.person1_id)
            format.html { redirect_to person_path(@person), notice: I18n.t('activerecord.success.messages.created', model: I18n.t('children.form.child')) }
            format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('children.form.child')) }
          else
            format.html { render 'children/new', status: :unprocessable_entity }
            flash.now[:notice] = @couple.errors.full_messages[0]
            format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
          end
        else
          format.html { redirect_to person_path(@person), notice: I18n.t('activerecord.success.messages.created', model: I18n.t('people.form.person')) }
          format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('people.form.person')) }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        flash.now[:notice] = @person.errors.full_messages[0]
        format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      @person.current_user = current_user
      if @person.update(person_params)
        if @person.saved_changes?
          format.html { redirect_to person_path(@person), notice: I18n.t('activerecord.success.messages.updated', model: I18n.t('people.form.person')) }
          format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.updated', model: I18n.t('people.form.person')) }
        else
          format.html { redirect_to person_path(@person) }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        flash.now[:notice] = @person.errors.full_messages[0]
        format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    authorize @person
    person_name = @person.name
    @person.destroy

    respond_to do |format|
      format.html { 
        redirect_to people_path, 
        notice: I18n.t('activerecord.success.messages.deleted', model: I18n.t('people.form.person')) 
      }
      format.turbo_stream { 
        redirect_to people_path, 
        notice: I18n.t('activerecord.success.messages.deleted', model: I18n.t('people.form.person'))
      }
      format.json { head :no_content }
    end
  end

  def search_child
    @q = Person.without_recorded_parents.where.not(id: session[:id]).ransack(params[:q])
    @people = params[:q].nil? ? [] : @q.result(distinct: true)
  end

  def search_mate
    @q = Person.P.where.not(id: session[:id]).ransack(params[:q]) if session[:gender] == 'P'
    @q = Person.not_P.not_M.ransack(params[:q]) if session[:gender] == 'M'
    @q = Person.not_P.not_F.ransack(params[:q]) if session[:gender] == 'F'
    @q = Person.not_P.where.not(id: session[:id]).ransack(params[:q]) if session[:gender] == 'X'
    @people = params[:q].nil? ? [] : @q.result(distinct: true)
  end

  def birthdays
    # Get birthdays from user's favorite people, or all people if no favorites
    if current_user&.favorite_people&.any?
      authorize current_user.favorites, :index?
      @people_with_birthdays = Person.upcoming_birthdays_for_people(current_user.favorite_people, 7, 7)
      @showing_favorites = true
    else
      authorize Person, :birthdays?
      @people_with_birthdays = Person.upcoming_birthdays(7, 7)
      @showing_favorites = false
    end
    
    # Group by days until birthday for better organization
    @past_birthdays = @people_with_birthdays.select { |p| p.days_until_birthday < 0 }
    @today_birthdays = @people_with_birthdays.select { |p| p.days_until_birthday == 0 }
    @upcoming_birthdays = @people_with_birthdays.select { |p| p.days_until_birthday > 0 }
  end

  private

  def search_active?
    params[:q].present?
  end

  def set_person
    @person = Person.includes(
      :couples,
      couples: [:person1, :person2, :people]
    ).find(params[:id])
  end

  def person_params
    permitted_params.except(:couple, :mate, :marriage, :separation, :local)
  end

  def couple_params
    permitted_params.slice(:couple, :mate, :marriage, :separation, :local)
  end

  def permitted_params
    params.require(:person).permit(:name, :kanji, :gender, :alive, :birth_year, :birth_month, :birth_day, :death_year, :death_month, :death_day, :description,
                                   :avatar, :couple, :mate, :marriage, :separation, :local)
  end
end
