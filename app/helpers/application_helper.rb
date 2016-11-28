module ApplicationHelper
	def get_title
		title = "Shop"
		title += " | #{@title}" unless @title.nil?
		return title
	end	

	def set_month month
  	month_names = ["Січня", "Лютого", "Березня", "Квітня", "Травня", "Червня", "Липня", "Серпня", "Вересня", "Жовтня", "Листопада", "Грудня"]
  	month_names[month - 1];
  end	

  def plural_form(number, array_str) 
  	cases = [2, 0, 1, 1, 1, 2]
		return number.to_s + " " + array_str[ (number%100 > 4 && number % 100 < 20) ? 2 : cases[[number%10, 5].min] ]
	end 

	def get_error_messages object
		return "" if object.errors.empty?
		messages = object.errors.messages.map { |key, msg| "<li>#{msg.first}</li>" }.join
    "<div class='error-messages'><h4>Виправте #{plural_form(object.errors.count, ['помилку', 'помилки', 'помилок'])}: </h4><ul>#{messages}</ul></div>".html_safe
	end	

	def get_notice
		return "" if notice.nil?
		"<div id=notice>#{notice}</div>".html_safe
	end	

	def get_orders_unverified_count
		@orders_count = Order.where(unverified: true).count if @orders_count.nil?
		
		if @orders_count.zero?
			return ''
		else
			return "<span class='order-counter'>#{@orders_count}</span>".html_safe
		end	
	end

	def set_cart_params
		if session[:cart_id]
			@cart_count = Cart.find(session[:cart_id]).total_count
			@cart_price = Cart.find(session[:cart_id]).total_price
		else
			@cart_count = 0
			@cart_price = 0.00
		end	
	end	
end
