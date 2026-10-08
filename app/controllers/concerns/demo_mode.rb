# app/models/concerns/demo_mode.rb
module DemoMode
  def demo_mode?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch('DEMO_MODE', nil)) || false
  end
end
