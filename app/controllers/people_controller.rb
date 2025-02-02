# frozen_string_literal: true

# This controller manages the people in the family tree.
class PeopleController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_person, only: %i[show edit update destroy]

  # GET /people or /people.json
  def index
    @q = Person.ransack(params[:q])
    @pagy, @people = pagy(@q.result(distinct: true), items: 10)
  end

  def download
    @people = Person.all
    respond_to do |format|
      format.csv do
        authorize Person
        send_data Person.to_csv(@people), filename: "people-#{Date.today}.csv"
      end
    end
  end

  # GET /people/1 or /people/1.json
  def show
    @parents = @person.couples
    if @parents.empty?
      @father = nil
      @mother = nil
    else
      if Person.find(@parents[0].person1_id).gender == 'M'
        @father = Person.find(@parents[0].person1_id)
        @mother = Person.find(@parents[0].person2_id)
      else
        @father = Person.find(@parents[0].person2_id)
        @mother = Person.find(@parents[0].person1_id)
      end
    end

    @mate = []
    @couple = []
    @children = []
    couple = Couple.where(person1_id: @person).or(Couple.where(person2_id: @person))
    return if couple.empty?

    couple.each do |mate|
      @mate << Person.find(mate.person1_id) unless mate.person1_id == @person.id
      @mate << Person.find(mate.person2_id) unless mate.person2_id == @person.id
      @couple << mate
      mate.people.each do |child|
        @children << child
      end
    end
  end

  # GET /people/new
  def new
    @person = Person.new
    authorize @person
  end

  # GET /people/1/edit
  def edit
    authorize @person
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)
    authorize @person
    @partner = nil
    @child = nil

    respond_to do |format|
      if @person.save!
        if couple_params[:mate].present?
          @couple = Couple.new(person1_id: couple_params[:mate], person2_id: @person.id, marriage: couple_params[:marriage],
                               separation: couple_params[:separation], local: couple_params[:local])
          authorize @couple

          if @couple.save
            FamilyMailer.with(user: current_user, couple: @couple).couple_created.deliver_later
            @partner = Person.find(@couple.person1_id)
            format.html { redirect_to person_url(@person) }
            format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('couples.form.couple')) }
          else
            format.html { render :new, status: :unprocessable_entity }
            flash.now[:notice] = @couple.errors.full_messages[0]
            format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
          end
        elsif couple_params[:couple].present?
          @couple = Couple.find(couple_params[:couple])
          authorize @couple

          if @couple.people << @person
            FamilyMailer.with(user: current_user, child: @person, couple: @couple).child_created.deliver_later
            @child = @person
            @person = Person.find(@couple.person1_id)
            format.html { redirect_to person_path(@person) }
            format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('children.form.child')) }
          else
            format.html { render 'children/new', status: :unprocessable_entity }
            flash.now[:notice] = @couple.errors.full_messages[0]
            format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
          end
        else
          FamilyMailer.with(user: current_user, person: @person).person_created.deliver_later
          format.html { redirect_to person_url(@person) }
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
    authorize @person
    respond_to do |format|
      if @person.update(person_params)
        FamilyMailer.with(user: current_user, person: @person).person_updated.deliver_later
        format.html { redirect_to person_url(@person) }
        format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.updated', model: I18n.t('people.form.person')) }
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
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.deleted', model: I18n.t('people.form.person')) }
      format.json { head :no_content }
    end
  end

  def search_child
    @q = Person.without_recorded_parents.where.not(id: session[:id]).ransack(params[:q])
    @people = params[:q].nil? ? [] : @q.result(distinct: true)

    # if params[:q].nil?
    #   @people = []
    # else
    #   @people = @q.result(distinct: true)
    # end
    authorize @people
  end

  def search_mate
    @q = Person.P.where.not(id: session[:id]).ransack(params[:q]) if session[:gender] == 'P'
    @q = Person.not_P.not_M.ransack(params[:q]) if session[:gender] == 'M'
    @q = Person.not_P.not_F.ransack(params[:q]) if session[:gender] == 'F'
    @q = Person.not_P.where.not(id: session[:id]).ransack(params[:q]) if session[:gender] == 'X'
    @people = params[:q].nil? ? [] : @q.result(distinct: true)
    # if params[:q].nil?
    #   @people = []
    # else
    #   @people = @q.result(distinct: true)
    # end
    authorize @people
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    permitted_params.except(:couple, :mate, :marriage, :separation, :local)
  end

  def couple_params
    permitted_params.slice(:couple, :mate, :marriage, :separation, :local)
  end

  def permitted_params
    params.require(:person).permit(:name, :kanji, :gender, :alive, :birth, :death, :description,
                                   :avatar, :couple, :mate, :marriage, :separation, :local)
  end
end
