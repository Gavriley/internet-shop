require 'rails_helper'

describe ProductsController do
	describe 'index product' do
		it 'success response index product path' do 
			get :index
			expect(response).to be_success
		end

		it 'load all of the products into @products' do
			first_product, second_product, third_product = FactoryGirl.create(:product), FactoryGirl.create(:product), FactoryGirl.create(:product)

			# puts "#{first_product.price} #{second_product.price} #{third_product.price}"

			get :index
			expect(assigns(:products)).to match_array([first_product, second_product, third_product])
		end	

		it 'assigns @products' do
			product = FactoryGirl.create(:product)
			get :index
			expect(assigns(:products)).to eq([product])
		end	
	end

	describe 'new product' do
		it 'success response new product path' do
			get :new
			expect(response).to be_success
		end	

		it 'render new product template' do
			get :new
			expect(response).to render_template("new")
		end	
	end
end	