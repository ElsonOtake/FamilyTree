# frozen_string_literal: true

# This controller manages the roles in the family tree.
class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize Role }

  def index
    @roles = Role.all
    respond_to do |format|
      format.html
      format.csv do
        send_data Role.to_csv(Role.with_deleted.order(:id)), filename: "roles-#{Date.today}.csv"
      end
    end
  end
end
