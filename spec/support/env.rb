Capybara.register_driver :chrome do |app|
	  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--start-maximized" ]})
  $driver = Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps})
  client = Selenium::WebDriver::Remote::Http::Default.new

  client.timeout = 120
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :http_client => client)
end

Capybara.javascript_driver = :chrome

# require 'headless'

#   headless = Headless.new
#   headless.start

