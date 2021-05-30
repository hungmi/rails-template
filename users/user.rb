class User < ApplicationRecord
	enum role: { admin: 0, normal: 1 }

	validates :name, presence: true, uniqueness: true
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

	has_secure_password
end