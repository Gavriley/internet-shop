class Admin::UsersController < Admin::AdminController
	before_action :set_user, only: [:edit, :update, :destroy]
	before_action :delete_avatar, only: :update

	def index
		@title = "Користувачі"

		set_search_users
		
		respond_to do |format|
			format.html { render :index }
			format.js { render :users }
		end
	end
	
	def new
		@user = User.new
		set_roles
	end	

	def edit
		@title = "Користувач #{@user.login}"
		set_roles
	end	

	def create
		@user = User.new(user_params)

		if @user.save
			redirect_to edit_admin_user_path(@user), notice: "Користувач успішно створений", format: :js
		else
			render :create, format: :js
		end	
	end	

	def update
		if user_params[:password].empty?
			flash[:alert] = "Користувач успішно оновлений" if @user.update_without_password(user_params)
		else
			flash[:alert] = "Користувач успішно оновлений" if @user.update(user_params)
		end

		render :update, format: :js
	end	


	def destroy
		@user.destroy
		redirect_to admin_users_path
	end

	private
		def set_roles
			@roles = Role.where.not(name: :guest)
		end	

		def set_user
			@user = User.find(params[:id])
		end		

		def user_params
			params.require(:user).permit(:login, :email, :name, :password, :avatar, :role_id)
		end	

		def set_search_users
			@search = User.search(include: [:role, :products]) do
				fulltext params[:search_user]

				paginate page: params[:page], per_page: 10
				order_by :id, :desc
			end

			@users = @search.results
		end	

		def delete_avatar
	    @user.avatar.try(:destroy) and @user.save if params[:drop_file]
	  end  
end	