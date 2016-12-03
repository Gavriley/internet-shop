class PaymentMailer < ApplicationMailer

	def send_payment(order)
		@order = order
		mail(to: @order.email, subject: "Ви заказали товари")
	end
	
	def send_success_message(order)
		@order = order
		mail(to: @order.email, subject: "Товари успішно оплачені")
	end

	def send_error_message(order)
		@order = order
		mail(to: @order.email, subject: "Помилка при оплаті")
	end	
end
