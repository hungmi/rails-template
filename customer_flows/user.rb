class User < ApplicationRecord
	has_one_attached :avatar
	
	validates :email, confirmation: true, presence: { message: "請填寫電子郵件" }, uniqueness: { message: "電子郵件已經被使用" }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "請確認您的電子郵件", allow_blank: true }
	validates :phone_number, format: { with: /\A(09|8869)\d{8}\Z/, message: "您輸入的手機號碼格式不正確。", allow_blank: true }

	enum role: { customer: 0, admin: 1 }
	has_secure_password
	has_secure_token :reset_token # 重設密碼
	has_secure_token :confirmation_token # 註冊後驗證信箱

	attr_accessor :email_confirmation # 修改個人資料時，重複輸入 email

	def name
		"#{last_name}#{first_name}"
	end

	def self.to_csv
    require "csv"
    CSV.generate(headers: true) do |csv|
      csv << ["email", "name", "provider", "created_at"].map do |attr|
        User.human_attribute_name(attr)
      end
      
      all.each do |user|
        csv << [user.email, user.name, user.provider, user.created_at.strftime('%F')]
      end
    end
  end
end