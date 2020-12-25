namespace :admin_user do
  desc "create first admin user"
  task :install => :environment do
    User.create(email: "a@email.com", name: "it", password: "123456", password_confirmation: "123456", role: "admin", confirmed_at: Time.zone.now)
  end
end