class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    @first = Person.select("upper(left(name, 1)) initial").distinct.order(:initial)
    @people = Person.where('name like ?', "#{@first[0].initial}%").order(:name)
  end

  # GET /people/1 or /people/1.json
  def show
    @parents = @person.couples
    if @parents.empty?
      @father = nil
      @mother = nil
    else
      if Person.find(@parents[0].person1_id).gender = "M"
        @father = Person.find(@parents[0].person2_id)
        @mother = Person.find(@parents[0].person1_id)
      else
        @father = Person.find(@parents[0].person1_id)
        @mother = Person.find(@parents[0].person2_id)
      end
    end
      
    @mate = []
    @children = []
    couple = Couple.where(person1_id: @person).or(Couple.where(person2_id: @person))
    if !couple.empty?
      couple.each do |mate|
        @mate << Person.find(mate.person1_id) unless mate.person1_id == @person.id
        @mate << Person.find(mate.person2_id) unless mate.person2_id == @person.id
        mate.people.each do |child|
          @children << child
        end
      end
    end
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:name, :gender, :alive, :birth, :death, :description)
    end
end
