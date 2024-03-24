class ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person
  before_action :set_couple
  def index
  end

  def new
    @q = Person.ransack(params[:q])
    session[:id] = @person.id
    @people = []
  end

  def create
    @child = Person.find(params[:child_id])
    
    respond_to do |format|
      if @couple.people << @child
        FamilyMailer.with(user: current_user, child: @child, couple: @couple).child_created.deliver_later
        format.html { redirect_to person_path(@person), notice: "Child was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Child was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash.now[:notice] = @couple.errors.full_messages[0]
        format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @child = Person.find(params[:id])
    @child.couple_ids = nil

    respond_to do |format|
      format.html { redirect_to person_url(@person), notice: "Child was successfully erased." }
      format.turbo_stream { flash.now[:notice] = "Child was successfully erased." }
    end
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
