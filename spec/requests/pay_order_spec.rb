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
		Role.create([{ name: 'admin', title: 'Адміністратор' }, { name: 'manager', title: 'Менеджер' }, { name: 'client', title: 'Клієнт' }, { name: 'guest', title: 'Гість' }])

  	sign_in FactoryGirl.create(:user)
  	3.times { FactoryGirl.create(:product) }

		visit products_path
		find_all('.button-cart').each { |link| link.click }

		puts find('#cart').text
	end

	# it 'create order in 2008' do
	# 	time = Time.local(2008, 9, 1, 10, 5, 0)
 #  	Timecop.travel(time)
 #  	Timecop.scale(3600)
 #  	Timecop.freeze(Time.now)
 #  	sleep(1)

 #  	visit carts_path

 #  	user = User.last
  	
 #  	fill_in 'Введіть e-mail', with: user.email
 #  	fill_in 'Введіть імя', with: user.name
 #  	fill_in 'Введіть адресу', with: 'Коновальця'

	# 	click_button 'Оформити заказ'

	# 	puts Order.last.created_at
	# end	

	it 'create order' do

		visit carts_path

		page.find_by_id('push_order').click

  	fill_in 'Введіть адресу', with: 'Коновальця'

		click_button 'Оформити заказ'

		# page.find('.stripe-button-el').click

		expect(page).to have_content "0шт. - 0.00 грн."
		expect(page).to have_content "Заказ №"
	end	

	it 'missing form data' do
		sign_out :user

		visit carts_path

		page.find_by_id('push_order').click
		
		click_button 'Оформити заказ'

		expect(page).to have_content "Заповніть поле e-mail"
		expect(page).to have_content "Заповніть поле імя"
		expect(page).to have_content "Заповніть поле адреса"
	end	

	context 'if delete line items from cart' do
		before(:each) do 
			visit carts_path

			Cart.last.line_items.delete_all
		end	

		it 'fill form' do

			page.find_by_id('push_order').click

	  	fill_in 'Введіть адресу', with: 'Коновальця'

	  	click_button 'Оформити заказ'

			expect(page).to have_content "0шт. - 0.00 грн."
			expect(page).to have_content "Помилка при формуванні заказу"
		end	
	end	
end	