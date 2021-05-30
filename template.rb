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
  copy_file "admin/admin_controller.rb", "app/controllers/admin_controller.rb"
  copy_file "admin/admin_policy.rb", "app/policies/admin_policy.rb"
  copy_file "admin/admin.sass", "app/javascript/stylesheets/admin.sass"
  copy_file "admin/admin.js", "app/javascript/packs/admin.js"
  copy_file "admin/sortable.js", "app/javascript/packs/sortable.js"
  # copy_file "admin/bootstrap.min.css", "app/javascript/stylesheets/bootstrap.min.css"
  copy_file "admin/tablesort.min.css", "app/javascript/stylesheets/tablesort.min.css"
  template "admin/admin.html.erb", "app/views/layouts/admin.html.erb"
  copy_file "admin/admin_helper.rb", "app/helpers/admin_helper.rb"
  template '_nav_top.html.erb', "app/views/admin/common/_nav_top.html.erb"
  template "_search_modal.html.erb", "app/views/admin/common/_search_modal.html.erb"
  template "_short_search_input_group.html.erb", "app/views/admin/common/_short_search_input_group.html.erb"
  template "_resources_header.html.erb", "app/views/admin/common/_resources_header.html.erb"
  template "_image_field.html.erb", "app/views/admin/common/_image_field.html.erb"
  template "_images_field.html.erb", "app/views/admin/common/_images_field.html.erb"
  copy_file "record_not_found.js.erb", "app/views/admin/common/record_not_found.js.erb"
end

def create_admin_routes
  route "get 'admin', to: redirect('/admin/users')"
  inject_into_file "config/routes.rb", before: /^end/ do <<-RUBY.strip_heredoc
      resources :sessions, only: [:new, :create, :destroy]
      resources :passwords, only: [:show, :edit, :update] # 重置密碼成功頁面, 改密碼的頁面, 密碼更新
      namespace :passwords do
        resources :resets, only: [:new, :show, :create] # 申請設定新密碼信件頁面, 設定新密碼信件已寄出頁面, 寄出設定新密碼信件
      end
      namespace :admin do
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
  # 首先產生不需要密碼及確認密碼的 migration file
  `rails g model users name:string:index email:string:index role:integer password:digest`
  # 然後再產生其他的 model, view 等等的，不要覆蓋 migration file 就好
  `rails g dashboard users name:string:index role:integer password:string password_confirmation:string --skip-creating-model true`
  # 首先產生不需要密碼及確認密碼的 migration file
  # `rails g migration create_users name:string:index role:integer password:digest -f`
  template "users/user.rb", "app/models/user.rb", force: true
  copy_file "users/_form.html.erb", "app/views/admin/users/_form.html.erb", force: true
end

def copy_sessions_files
  copy_file "users/sessions/css/sessions.sass", "app/javascript/stylesheets/sessions.sass"
  template "users/sessions/views/new.html.erb", "app/views/sessions/new.html.erb"
  copy_file "users/sessions/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
end

def copy_passwords_files
  copy_file "users/passwords/controllers/passwords_controller.rb", "app/controllers/passwords_controller.rb"
  template "users/passwords/views/passwords/edit.html.erb", "app/views/passwords/edit.html.erb"
  template "users/passwords/views/passwords/show.html.erb", "app/views/passwords/show.html.erb"
end

def copy_password_resets_files
  copy_file "users/password_resets/controllers/passwords/resets_controller.rb", "app/controllers/passwords/resets_controller.rb"
  template "users/password_resets/views/passwords/resets/new.html.erb", "app/views/passwords/resets/new.html.erb"
  template "users/password_resets/views/passwords/resets/show.html.erb", "app/views/passwords/resets/show.html.erb"
  template "users/password_resets/views/passwords/resets/_has_email.html.erb", "app/views/passwords/resets/_has_email.html.erb"
  template "users/password_resets/views/passwords/resets/_no_email.html.erb", "app/views/passwords/resets/_no_email.html.erb"
end

def copy_rake_files
  copy_file "rake/admin_user.rake", "lib/tasks/admin_user.rake"
  copy_file "rake/dev.rake", "lib/tasks/dev.rake"
end

def copy_seeds
  copy_file "seeds.rb", "db/seeds.rb"
end

## 以上生成管理員、登入頁、登入授權

def copy_stimulus_files
  copy_file "stimulus/storage_previewable_controller.js", "app/javascript/controllers/storage_previewable_controller.js"
  copy_file "stimulus/flat_pickr_controller.js", "app/javascript/controllers/flat_pickr_controller.js"
end

def override_files
  copy_file "application_controller.rb", "app/controllers/application_controller.rb", force: true
  copy_file "application_helper.rb", "app/helpers/application_helper.rb", force: true
  remove_file "app/assets/stylesheets/application.css"
  template "application.scss", "app/javascript/stylesheets/application.scss"
end

def add_gems
  # gem 'bullet', group: [:development]
  gem 'amazing_print', group: [:development]
  gem 'pry'
  gem 'pry-rails', group: [:development]
  gem 'bullet', group: [:development]
  gem 'pundit'
  gem 'delayed_job_active_record'
  gem 'daemons'
  gem "browser"
  gem 'ransack', github: 'activerecord-hackery/ransack'
  gem "aws-sdk-s3", require: false
  gem 'bcrypt', '~> 3.1.7'
  gem 'redis', '~> 4.0'
  gem 'pagy'
  gem 'whenever', require: false
  gem 'image_processing', '~> 1.2'
  gem 'mimemagic', '~> 0.3.10' # 因為此gem某些版本已被移除，因此需要指定版本
  gem 'hotwire-rails'
end

def copy_gem_setting_files
  copy_file "schedule.rb", "config/schedule.rb", force: true
  copy_file "pagy.rb", "config/initializers/pagy.rb"
end

def setup_locale_and_timezone
  application do
    "config.i18n.default_locale = 'zh-TW'\nconfig.time_zone = 'Taipei'"
  end
  copy_file "zh-TW.yml", "config/locales/zh-TW.yml"
end

def setup_gcs_on_production
  gsub_file 'config/environments/production.rb', 'config.active_storage.service = :local', 'config.active_storage.service = :google'
end

def setup_delayed_job_on_production
  inject_into_file "config/environments/production.rb", before: /^end/ do <<-RUBY.strip_heredoc
      config.active_job.queue_adapter = :delayed_job
    RUBY
  end
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

def setup_dbbackup_rb
  inject_into_file "app/models/dbbackup.rb", before: /^end/ do <<-RUBY.strip_heredoc
      has_one_attached :file
    RUBY
  end
end

def setup_environment_js_for_bootstrap_in_webpack
  insert_into_file "config/webpack/environment.js", after: "const { environment } = require('@rails/webpacker')\n" do
    "const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}))"
  end
end

def yarn_add_bootstrap
  `yarn add jquery bootstrap @popperjs/core tablesort flatpickr`
end

#---------------------
add_template_repository_to_source_path
add_gems
create_admin_files
create_admin_routes
# setup_assets_rb # 已經沒有使用 asset pipeline
copy_sessions_files
copy_passwords_files
copy_password_resets_files
copy_rake_files
override_files
setup_locale_and_timezone
setup_gcs_on_production
setup_delayed_job_on_production
setup_environment_rb
copy_dashbaord_generator

after_bundle do
  run "spring stop"
  generate "pundit:install"
  `wheneverize .`
  `rails active_storage:install`
  generate_user_dashboard
  `rails g model dbbackup name:string`
  setup_dbbackup_rb
  # `rails db:environment:set RAILS_ENV=development`
  copy_gem_setting_files
  # setup_environment_js_for_bootstrap_in_webpack
  yarn_add_bootstrap
  copy_stimulus_files
  `bin/rails hotwire:install`
  `bin/rails action_text:install`
  `rails g delayed_job:active_record`
  `RAILS_ENV=development rails db:create db:migrate`
end

