require 'rails_helper'
require 'selenium-webdriver'

describe 'PayOrder', { type: :feature, js: true } do 
	# before(:all) do 
	# 	@browser = $browser = Selenium::WebDriver.for :chrome
	# 	# @blowser.get('localhost:3000')
	# 	@browser.navigate.to "http://google.com"
	# end	

	# after(:all) do
	# 	$browser.quit
	# end	

	before(:each) do 
		visit root_path
  	sign_in FactoryGirl.create(:user)
  	5.times { FactoryGirl.create(:product) }
		
		visit products_path
		find_all('.button-cart').each { |link| link.click }

		puts find('#cart').text
	end

	it 'create order in 2008' do
		time = Time.local(2008, 9, 1, 10, 5, 0)
  	Timecop.travel(time)
  	Timecop.scale(3600)
  	Timecop.freeze(Time.now)
  	sleep(1)

  	visit carts_path

  	fill_in 'Введіть адресу', with: 'Коновальця'

		click_button 'Оформити заказ'

		puts Order.last.created_at
	end	

	it 'create order' do

		visit carts_path

		fill_in 'Введіть адресу', with: 'Коновальця'

		click_button 'Оформити заказ'

		expect(page).to have_content "0шт. - 0.00 грн."
		expect(page).to have_content "Заказ №"
	end	

	it 'missing form data' do
		sign_out :user

		visit carts_path

		click_button 'Оформити заказ'

		expect(page).to have_content "Заповніть поле e-mail"
		expect(page).to have_content "Заповніть поле імя"
		expect(page).to have_content "Заповніть поле адреса"
	end	

	it 'if delete line items from cart' do
		visit carts_path

		@cart = Cart.last

		@cart.line_items.delete_all

		fill_in 'Введіть адресу', with: 'Коновальця'

		click_button 'Оформити заказ'

		expect(page).to have_content "0шт. - 0.00 грн."
		expect(page).to have_content "Помилка при формуванні заказу"
	end	
end	