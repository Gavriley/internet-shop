# Capybara.register_driver :chrome do |app|
#   client = Selenium::WebDriver::Remote::Http::Default.new
#   client.timeout = 120
#   Capybara::Selenium::Driver.new(app, :browser => :chrome, :http_client => client)
# end

# Capybara.javascript_driver = :chrome

# require 'headless'

#   headless = Headless.new
#   headless.start