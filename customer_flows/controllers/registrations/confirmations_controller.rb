class Registrations::ConfirmationsController < ApplicationController
  def new
  end

  def show
    @user = User.find_by(id: params[:id], confirmation_token: params[:token])
    if @user.present?
      @user.update(confirmed_at: Time.zone.now) unless @user.confirmed_at.present?
      flash[:normal] = "信箱驗證成功。"
      if user_signed_in?
        redirect_to profile_users_path # TODO 確認個人資料路徑是否為 /users/profile
      else
        redirect_to sign_in_path
      end
    else
      flash[:not_authorized_error] = "找不到對應的使用者"
      redirect_to root_path
    end
  end
end