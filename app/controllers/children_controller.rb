# frozen_string_literal: true

# This controller manages the children in the family tree.
class ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person, except: %i[download]
  before_action :set_couple, except: %i[download]
  before_action -> { authorize Child }

  def download
    children = Person.with_deleted.joins(:couples).select('person_id, couple_id')
    respond_to do |format|
      format.csv do
        send_data Child.to_csv(children), filename: "children-#{Date.today}.csv"
      end
    end
  end

  def new
    @q = Person.ransack(params[:q])
    session[:id] = @person.id
    @people = []
  end

  def create
    @child = Person.find(params[:child_id])
    # The link may already exist as a soft-deleted row (the composite PK allows
    # only one per pair); restore it instead of inserting a duplicate.
    @child_record = Child.with_deleted.find_or_initialize_by(person_id: @child.id, couple_id: @couple.id)
    @child_record.current_user = current_user

    respond_to do |format|
      if link_child(@child_record)
        format.html { redirect_to person_path(@person) }
        format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.created', model: I18n.t('children.form.child')) }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash.now[:notice] = @child_record.errors.full_messages[0]
        format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_inline_flash_messages }
      end
    end
  end

  def destroy
    @child = Person.find(params[:id])
    @child_record = Child.find_by(person_id: @child.id, couple_id: @couple.id)

    unless @child_record
      respond_to do |format|
        format.html do
          redirect_to person_url(@person), alert: I18n.t('children.errors.relationship_not_found')
        end
        format.turbo_stream do
          flash.now[:alert] = I18n.t('children.errors.relationship_not_found')
          render turbo_stream: helpers.render_turbo_stream_inline_flash_messages
        end
      end
      return
    end

    # Check if person has any remaining children before destroying (avoids reload)
    @has_remaining_children = @person.parent_relationships.where.not(couple_id: @couple.id).exists?

    @child_record.current_user = current_user
    @child_record.destroy

    respond_to do |format|
      format.html { redirect_to person_url(@person) }
      format.turbo_stream { flash.now[:notice] = I18n.t('activerecord.success.messages.unlinked', model: I18n.t('children.form.child')) }
    end
  end

  private

  # Create the link, restore a previously unlinked (soft-deleted) one (auditing
  # the re-link), or reject a link that already exists and is active (the no-op
  # save would otherwise report a false success).
  def link_child(record)
    return record.save unless record.persisted?

    if record.deleted_at?
      return false unless record.restore

      record.record_relink(current_user)
      return true
    end

    record.errors.add(:person_id, :taken)
    false
  end

  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_couple
    @couple = Couple.find(params[:couple_id])
  end
end
