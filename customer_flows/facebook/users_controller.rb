class Facebook::UsersController < ApplicationController
  def create
  	if request.env['omniauth.auth'].present?
      logger.info request.env['omniauth.auth']
      user = User.where(oauth_uid: request.env['omniauth.auth']['uid']).first_or_initialize do |user|
      	# 若有找到 user，並不會進來 block
      	user.oauth_token = request.env['omniauth.auth']['credentials']['token']
      	user.expires_at = Time.at(request.env['omniauth.auth']['credentials']['expires_at'])
      	user.first_name = request.env['omniauth.auth']['info']['first_name']
      	user.last_name = request.env['omniauth.auth']['info']['last_name']
      	user.email = request.env['omniauth.auth']['info']['email']
      	user.password_digest = BCrypt::Password.create('wassupisverycoolisntit?') # 只要是一個很長的密碼就好
      	user.provider = "facebook"
        user.confirmed_at = Time.zone.now
      	user.save!
      end
      if user.persisted?
        unless user.avatar.attached?
          require 'open-uri'
        	downloaded_image = URI.open(request.env['omniauth.auth']['info']['image'])
        	user.avatar.attach(io: downloaded_image, filename: 'avatar.jpg', content_type: downloaded_image.content_type)
        end
        sign_in_and_redirect_to_back_path(user)
      end
    end
  end

  def oauth_failure
  	flash[:fb_error] = "很抱歉，FB 登入失敗 :("
  	redirect_to sign_in_path
  end
end