# frozen_string_literal: true

# app/models/concerns/demo_mode.rb
module DemoMode
  def demo_mode?
    ActiveModel::Type::Boolean.new.cast(ENV['DEMO_MODE']) || false
  end
end
