class PasswordsController < ApplicationController
  def show
  end

  def edit
    @user = User.find_by(id: params[:id], reset_token: params[:token])
    unless @user.present?
      flash[:not_authorized_error] = "找不到對應的使用者"
      redirect_to root_path
    end
  end

  def update
    # TODO 每次設定完新密碼應重新產生 user.reset_token
    @user = User.find_by(id: params[:id])
    if @user.update(password_params)
      flash[:normal] = "更改密碼成功"
      @user.regenerate_reset_token
      redirect_to sign_in_path
    else
      flash.now[:error] = "出現錯誤"
      render :edit
    end
  end

  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end