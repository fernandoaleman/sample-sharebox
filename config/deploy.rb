set :application, "sharebox"
set :repository,  "git://github.com/fernandoaleman/sample-sharebox.git"

set :user, :deployer
set :deploy_to, "/var/www/html/apps/#{application}"
set :use_sudo, false

set :scm, :git

role :web, "192.168.180.129"                          # Your HTTP server, Apache/etc
role :app, "192.168.180.129"                          # This may be the same as your `Web` server
role :db,  "192.168.180.129", :primary => true # This is where Rails migrations will run
role :db,  "192.168.180.129"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end