# frozen_string_literal: true

# This controller manages the roles in the family tree.
class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize Role }

  def download
    roles = Role.with_deleted.order(:id)
    respond_to do |format|
      format.csv do
        send_data Role.to_csv(roles), filename: "roles-#{Date.today}.csv"
      end
    end
  end
end
