set :application, "yourhires"
set :deploy_to, "/var/www/#{application}"

default_run_options[:pty] = true
set :scm, :git
set :repository, "git@github.com:akshayrawat/yourhires-ng.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

set :use_sudo, false
set :user, "dev"
set :domain, "yourhires.ath.cx"
set :default_env, 'production'
set :rails_env, 'production'

role :app, "yourhires.ath.cx"
role :web, "yourhires.ath.cx"
role :db,  "yourhires.ath.cx", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

def run_remote_rake(rake_cmd)
    run "cd #{current_path} && rake RAILS_ENV=#{rails_env} #{rake_cmd}"
end

before "deploy:restart" do
  run_remote_rake("db:migrate:redo")
  run_remote_rake("db:seed")
	sudo("cp #{current_path}/config/yourhires_httpd.conf /etc/apache2/conf.d/")
end