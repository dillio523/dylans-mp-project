require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium,
            using: (ENV["DISABLE_HEADLESS_CHROME"].present? ? :chrome : :headless_chrome),
            screen_size: [1400, 1400] do |options|
    options.add_argument("no-sandbox")
  end

  def setup
    Capybara.server = :puma, { Silent: true }
    super
  end
end
