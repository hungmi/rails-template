class User < ApplicationRecord
	enum role: { admin: 0 }
	validates :name, presence: true, uniqueness: true
	has_secure_password
end