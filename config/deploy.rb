set :application, "yourhires"
set :deploy_to, "/var/www/#{application}"

set :repository, "git@github.com:akshayrawat/yourhires-ng.git"
set :branch, "master"

set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

default_run_options[:pty] = true

set :use_sudo, false
set :user, "dev"
set :domain, "yourhires.com"
set :scm, :git

role :app, "www.yourhires.com"
role :web, "www.yourhires.com"
role :db,  "www.yourhires.com", :primary => true

namespace :passenger do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

after "deploy:setup", "db:setup" 