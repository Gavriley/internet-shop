Capybara.register_driver :chrome do |app|
  # client = Selenium::WebDriver::Remote::Http::Default.new

  # client.timeout = 120
  # Capybara::Selenium::Driver.new(app, :browser => :chrome, :http_client => client)
  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--start-maximized" ]})
  $driver = Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps})
end
# Capybara.server_port = 3000
# Capybara.app_host = 'http://localhost:3000/'
Capybara.javascript_driver = :chrome

