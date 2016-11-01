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
end
