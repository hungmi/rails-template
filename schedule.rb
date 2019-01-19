# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
env :PATH, ENV['PATH'] #要用bundle時必須要加
set :output, "/home/deploy/railsapp/#{Rails.application.class.parent_name.underscore}/shared/log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
every 1.day, :at => "#{(Time.now + 3.minute).strftime("%H:%M %P")}" do
  # runner "MyModel.task_to_run_at_four_thirty_in_the_morning"
  runner "puts 'cron job works'"
end

every 1.day, at: '22:00 pm' do
  rake "dev:backup"
end