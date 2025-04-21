# frozen_string_literal: true

# This controller handles events collected from the family tree.
# It allows downloading the events in CSV format.
class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize Event }

  def download
    events = Event.order(:id)
    respond_to do |format|
      format.csv do
        send_data Event.to_csv(events), filename: "events-#{Date.today}.csv"
      end
    end
  end
end
