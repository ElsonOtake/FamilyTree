class ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person
  before_action :set_couple
  def index
  end

  def new
    @people = Person.where.not(id: Person.find_by_sql("Select person_id from couples_people").pluck(:person_id)).order(:name)
  end

  def create
    @child = Person.find(params[:child_id])
    
    respond_to do |format|
      if @couple.people << @child
        format.html { redirect_to person_path(@person), notice: "Child was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_couple
    @couple = Couple.find(params[:couple_id])
  end

  # Only allow a list of trusted parameters through.
  def child_params
    params.require(:child).permit(:child_id)
  end
end
