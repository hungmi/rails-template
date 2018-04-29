def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/hungmi/rails-template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def create_admin_files
  template "admin/admin_controller.rb", "app/controllers/admin_controller.rb"
  template "admin/admin_policy.rb", "app/policies/admin_policy.rb"
  template "admin/admin.scss", "app/assets/stylesheets/admin.scss"
  template "admin/admin.js", "app/assets/javascripts/admin.js"
  template "admin/admin.html.erb", "app/views/layouts/admin.html.erb"
  template '_nav_top.html.erb', "app/views/admin/common/_nav_top.html.erb"
end

def create_admin_routes
  route "get 'admin', to: redirect('/')"
  inject_into_file "config/routes.rb", before: /^end/ do <<-RUBY.strip_heredoc
      namespace :admin do
        get 'signin', to: 'sessions#new'
        post 'signin', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
      end
    RUBY
  end
end

def setup_assets_rb
  append_to_file 'config/initializers/assets.rb' do <<-RUBY.strip_heredoc

      Rails.application.config.assets.precompile += %w( admin.js admin.css )
    RUBY
  end
end

## 以下生成管理員、登入頁、登入授權
def generate_user_dashboard
  `rails g model users name:string role:integer password:string password_confirmation:string password:digest`
  `rails g dashboard users name:string role:integer password:string password_confirmation:string -s`
  template "model/user.rb", "app/models/user.rb", force: true
end

def copy_session_files
  copy_file "sessions/sessions.scss", "app/assets/stylesheets/admin/sessions.scss"
  template "sessions/signin.html.erb", "app/views/admin/sessions/new.html.erb"
  template "sessions/session_controller.rb", "app/controllers/admin/sessions_controller.rb"
  template "sessions/session_policy.rb", "app/policies/admin/session_policy.rb"
end

def copy_rake_files
  copy_file "rake/admin_user.rake", "lib/tasks/admin_user.rake"
  copy_file "rake/dev.rake", "lib/tasks/dev.rake"
end

## 以上生成管理員、登入頁、登入授權

def copy_vendor_files
  default_vendor_folder_path = "vendor/assets"
  copy_file "vendor/js/jquery.min.js", "#{default_vendor_folder_path}/js/jquery.min.js"
  copy_file "vendor/js/jquery.timeago.js", "#{default_vendor_folder_path}/js/jquery.timeago.js"
  copy_file "vendor/css/_bootswatch.scss", "#{default_vendor_folder_path}/css/_bootswatch.scss"
  copy_file "vendor/css/_variables.scss", "#{default_vendor_folder_path}/css/_variables.scss"
  copy_file "vendor/css/bootstrap.min.css", "#{default_vendor_folder_path}/css/bootstrap.min.css"
end

def override_files
  copy_file "application_controller.rb", "app/controllers/application_controller.rb", force: true
  copy_file "application_helper.rb", "app/helpers/application_helper.rb", force: true
  remove_file "app/assets/stylesheets/application.css"
  template "application.scss", "app/assets/stylesheets/application.scss"
end

def add_gems
  gem 'bullet', group: [:development]
  gem 'bootstrap', '~> 4.0.0'
  gem 'awesome_rails_console'
  gem 'pundit'
  gem 'sidekiq'
  gem "browser"
  gem 'ransack', github: 'activerecord-hackery/ransack'
  gem 'mini_magick', '~> 4.8'
  gem "aws-sdk-s3", require: false
  gem 'bcrypt', '~> 3.1.7'
  gem 'redis', '~> 4.0'
end

def setup_locale_and_timezone
  application do
    "config.i18n.default_locale = 'zh-TW'\nconfig.time_zone = 'Taipei'"
  end
  copy_file "zh-TW.yml", "config/locales/zh-TW.yml"
end

def setup_es6_and_s3_production
  gsub_file 'config/environments/production.rb', 'config.assets.js_compressor = :uglifier', 'config.assets.js_compressor = Uglifier.new(harmony: true)'
  gsub_file 'config/environments/production.rb', 'config.active_storage.service = :local', 'config.active_storage.service = :amazon'
end

def setup_environment_rb
  append_to_file 'config/environment.rb' do <<-RUBY.strip_heredoc
      
      require "browser/aliases"
      Browser::Base.include(Browser::Aliases)
      ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
        html_tag.html_safe
      end
    RUBY
  end
end

def copy_dashbaord_generator
  directory "dashboard", "lib/generators/dashboard"
end

#---------------------
add_template_repository_to_source_path
add_gems
create_admin_files
create_admin_routes
setup_assets_rb
copy_session_files
copy_vendor_files
copy_rake_files
override_files
setup_locale_and_timezone
setup_es6_and_s3_production
setup_environment_rb
copy_dashbaord_generator

after_bundle do
  run "spring stop"
  generate "pundit:install"
  `rails active_storage:install`
  generate_user_dashboard
  rake 'db:rebuild'
end

