class RegistrationsController < ApplicationController
  def new
  end

  def create
  	user = User.where(email: params[:username]).first_or_initialize do |user|
  		# 若有找到 user，並不會進來 block
  		user.password = params[:password]
  		user.password_confirmation = params[:password_confirmation]
  		user.cats_count = params[:cats_count]
  		# 不要在這裡 save new user 不然下面無法判斷帳號是否重複
  	end
  	if user.persisted?
  		flash.now[:error] = "您輸入的帳號已有人使用。"
  		render :new
  	else
  		if user.save
  			redirect_to new_registrations_confirmation_path
  			RegistrationMailer.with(user: user).confirmation_mail.deliver_later
  		else
  			flash.now[:error] = user.errors.messages.values.join('，') # 密碼不一致、密碼空白
  			render :new
  		end
  	end
  end
end