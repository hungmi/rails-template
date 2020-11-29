class UsersController < ApplicationController
	rescue_from Pundit::NotAuthorizedError, with: :redirect_to_sign_in

  def show
  	authorize User
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
    else
      logger.info @user.errors.full_messages
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :phone_number, :first_name, :last_name, :cats_count)
  end
end