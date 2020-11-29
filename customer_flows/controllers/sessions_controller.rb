class SessionsController < ApplicationController
  def new
    if user_signed_in?
      redirect_to profile_users_path
    end
  end

  def create
  	user = User.find_by(email: params[:username]).try(:authenticate, params[:password])
  	if user.present?
      if user.confirmed_at.present?
  		  sign_in_and_redirect_to_back_path(user)
      else
        flash[:error] = "請先驗證信箱"
        redirect_to sign_in_path
      end
  	else
  		flash.now[:error] = "您輸入的帳號密碼不正確"
  		render :new
  	end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:back_path)
  	redirect_back(fallback_location: root_path)
  end
end