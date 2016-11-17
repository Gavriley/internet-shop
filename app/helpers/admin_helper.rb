module AdminHelper

	def get_panel_title 
		title = "Адмін панель"
		title += " | #{@title}" unless @title.nil?
		return title
	end	
end
