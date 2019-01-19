require 'rake'
namespace :db do
  desc "build db from scratch"
  task :build => [:environment] do |t, args|
    `RAILS_ENV=development rails db:create db:migrate db:seed admin_user:install`
  end

  desc "rebuild db from scratch"
  task :rebuild => [:environment] do |t, args|
    `RAILS_ENV=development rails db:drop db:create db:migrate db:seed admin_user:install`
  end
end
namespace :dev do
  desc "backup db"
  task :backup => [:environment] do |t, args|
    db_name = Rails.application.config.database_configuration[Rails.env]["database"]
    app_name = Rails.application.class.parent_name.underscore
    now = Time.now.strftime('%Y%m%d%H%M%S')
    puts "#{now}開始備份完整資料庫..."
    if Rails.env.production?
      @file_name = "#{app_name}_pro_#{now}.dump"
      `mkdir "/home/deploy/railsapp/#{app_name}/db_backups"`
      @local_dir = "/home/deploy/railsapp/#{app_name}/db_backups"
      # 記得要去 /home/deploy 創一個 .pgpass 然後 sudo chmod 600 /home/deploy/.pgpass
      `PGPASSFILE=/home/deploy/.pgpass pg_dump -Fc --no-acl --no-owner -h localhost -U deploy #{db_name} > "#{@local_dir}/#{@file_name}"`
      puts "開始上傳..."
      @dbbackup_record = Dbbackup.new(name: @file_name)
      @dbbackup_record.file.attach(io: File.open("#{@local_dir}/#{@file_name}"), filename: @file_name)
      @dbbackup_record.save
      puts "上傳成功，link: #{@dbbackup_record.file.service_url}"
    else
      @file_name = "#{app_name}_dev_#{now}.dump"
      `mkdir "/Users/hungmi/Documents/#{app_name}_aws"`
      @local_dir = "/Users/hungmi/Documents/#{app_name}_aws"
      `pg_dump -Fc --no-acl --no-owner -h localhost -U hungmi #{db_name} > "#{@local_dir}/#{@file_name}"`
      puts "備份完成"
    end
  end

  desc "restore db"
  task :restore, [:db_name] => :environment do |t, args|
    #db_link = Link.where(fetchable_type: "db").order(:id).last.value
    #`curl -O #{args[:db_name]} ~/Documents/longyun_aws`
    rails_db_name = Rails.application.config.database_configuration[Rails.env]["database"] 
    `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U hungmi -d #{rails_db_name} #{args[:db_name]}`
  end

  desc "restore db on production"
  task :restore_on_production, [:db_link] => :environment do |t, args|
    #db_link = Link.where(fetchable_type: "db").order(:id).last.value
    rails_db_name = Rails.application.config.database_configuration[Rails.env]["database"] 
    file_name = args[:db_link][/[^\/]*$/]
    @server_dir = "/home/deploy/longyun/db_backups"
    `wget -P #{@server_dir} #{args[:db_link]}`
    `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U longyun -d #{rails_db_name} #{@server_dir}/#{file_name}`
    # wget https://longyun-db2.s3-ap-northeast-1.amazonaws.com/longyun_dev_23.dump
    # pg_restore --verbose --clean --no-acl --no-owner -h localhost -U longyun -d longyun_production longyun_dev_23.dump
  end
end