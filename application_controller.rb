class ApplicationController < ActionController::Base
	protect_from_forgery unless: -> { request.format.json? } # 給 json api 模式使用
	before_action :remember_back_path, unless: -> { !request.get? || request.format.json? || request.format.js? }
	helper_method :current_user, :user_signed_in?

	include Pundit
	rescue_from Pundit::NotAuthorizedError, with: :redirect_to_sign_in

	def current_user
		@current_user ||= User.find_by_id(session[:user_id])
	end

	def user_signed_in?
		current_user.present?
	end

	def sign_in_and_redirect_to_back_path(user) # 此方法並非 pundit 相關，而是用在驗證信箱成功、FB 登入成功之後的自動登入。
		session[:user_id] = user.id
		if session[:back_path].present?
			logger.info "session[:back_path]: #{session[:back_path]}"
			redirect_to session[:back_path]
		else
			logger.info "redirecting back"
			redirect_back(fallback_location: root_path)
		end
	end

	private

	def remember_back_path
		unless "#{controller_path}##{action_name}".in?(["sessions#new", "facebook/users#create", "registrations#new", "registrations/confirmations#new", "registrations/confirmations#show", "passwords#edit"])
			session[:back_path] = request.fullpath
		end
		# p "BACK_PATH: #{session[:back_path]}"
	end

	def redirect_to_sign_in
		if user_signed_in?
      redirect_back(fallback_location: root_path)
    else
      redirect_to new_session_path
    end
	end
end