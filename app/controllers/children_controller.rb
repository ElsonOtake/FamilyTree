# frozen_string_literal: true

# This controller manages the children in the family tree.
class ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person, except: %i[download]
  before_action :set_couple, except: %i[download]

  def download
    # @children = Person.joins(:couples).select('person_id, couple_id')
    @children = Child.all
    respond_to do |format|
      format.csv do
        authorize Child
        send_data Child.to_csv(@children), filename: "children-#{Date.today}.csv"
      end
    end
  end

  def new
    authorize @person
    @q = Person.ransack(params[:q])
    session[:id] = @person.id
    @people = []
  end

  def create
    @child = Person.find(params[:child_id])
    authorize @child
    respond_to do |format|
      if @couple.people << @child
        FamilyMailer.with(user: current_user, child: @child, couple: @couple).child_created.deliver_later
        format.html { redirect_to person_path(@person) }
        format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('children.form.child')) }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash.now[:notice] = @couple.errors.full_messages[0]
        format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
      end
    end
  end

  def destroy
    @child = Person.find(params[:id])
    authorize @child
    @child.couple_ids = nil

    respond_to do |format|
      FamilyMailer.with(user: current_user, child: @child, couple: @couple).child_deleted.deliver_later
      format.html { redirect_to person_url(@person) }
      format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.unlinked', model: I18n.t('children.form.child')) }
    end
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
