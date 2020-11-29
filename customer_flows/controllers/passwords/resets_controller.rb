class Passwords::ResetsController < ApplicationController
	def create
		user = User.find_by(email: params[:username]) # TODO 確認 email 欄位名稱是否為 username
		if user.present?
			PasswordMailer.with(user: user).reset_mail.deliver_later
			redirect_to passwords_reset_path(id: "sent")
		else
			flash[:error] = "您似乎沒有申請過這個帳號。"
			redirect_to new_passwords_reset_path
		end
	end

  def show
  end
end