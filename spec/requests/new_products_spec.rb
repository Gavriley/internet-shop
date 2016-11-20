require 'rails_helper'

describe "NewProducts" do
	before(:all) do 
  	sign_in FactoryGirl.create(:user)
	end	

  it "when manger create new product" do
  	visit new_product_path
  	fill_in 'Введіть заголовок', with: "New Product Title"
  	fill_in 'Введіть ціну', with: '12000'

  	click_button 'Створити продукт'

  	expect(page).to have_content "Продукт успішно створений"
  end

  it "missing field title" do
  	visit new_product_path

  	fill_in 'Введіть ціну', with: '12000'

  	click_button 'Створити продукт'

  	expect(page).to have_content "Заповніть поле заголовок"
  end	

  it "missing field price" do
  	visit new_product_path

  	fill_in 'Введіть заголовок', with: "New Product Title"

  	click_button 'Створити продукт'

  	expect(page).to have_content "Введіть коректну ціну"
  end	

  it "when title has more than 70 chars" do
  	visit new_product_path
  	fill_in 'Введіть заголовок', with: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet possimus, rem a, quisquam totam magnam illum dolor quo reprehenderit praesentium eum in nisi eveniet laborum? Magni aperiam, nesciunt deleniti corporis. Nobis consequatur qui asperiores rerum odit, sit saepe quo, blanditiis illum obcaecati et veritatis, velit totam expedita rem dolor, voluptates animi. Distinctio ipsa culpa sapiente sint magni ea similique atque explicabo asperiores laudantium nobis, iusto dolore in excepturi voluptas doloremque!"
  	fill_in 'Введіть ціну', with: '12000'

  	click_button 'Створити продукт'

  	expect(page).to have_content "Заголовок може містити максимум 70 символів"
  end	

  it "when manager log out before create product" do
  	visit new_product_path

  	fill_in 'Введіть заголовок', with: "New Product Title"
  	fill_in 'Введіть ціну', with: '12000'

  	sign_out :user

  	click_button 'Створити продукт'

  	expect(page).to have_content "Помилка при добавленні товару"
  end	
end
