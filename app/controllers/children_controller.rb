class ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_couple
  def index
  end

  def new
    @people = Person.where.not(id: Person.find_by_sql("Select person_id from couples_people").pluck(:person_id)).order(:name)
  end

  def create
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

  def set_couple
    @couple = Couple.find(params[:couple_id])
  end
end
