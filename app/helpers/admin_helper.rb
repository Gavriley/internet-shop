module AdminHelper

	def get_panel_title 
		title = "Адмін панель"
		title += " | #{@title}" unless @title.nil?
		return title
	end		

	def get_ukr_order_state(state)
		case state
		when 'process'
			return 'в очікуванні'
		when 'sandbox'
			return 'оплачено'
		end		
	end	
end
