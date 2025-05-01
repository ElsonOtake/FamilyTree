# frozen_string_literal: true

# This controller manages pages in the family tree app.
class PagesController < ApplicationController
  before_action :authenticate_user!
  # before_action -> { authorize User }

  def about
  end
end
