set :application, "thebouldersocialclub"

#SCM settings
set :repository,  "git@github.com:ubermajestix/thebouldersocialclub.git"
set :scm, "git"
set :branch, "origin/master"
# set :repository_cache, "git_cache"
 set :deploy_via, :remote_cache


# Sudoer settings      
set :use_sudo               , true
set :user                   , "tyler"
set :runner                 , "root"
default_run_options[:shell] = false
default_run_options[:pty]   = true
set :ssh_options, { :forward_agent => true }
set :chmod755, "app config db lib public vendor script script/* public/disp*"

# Deployment servers
role :app, "thebouldersocialclub.com"
role :web, "thebouldersocialclub.com"
role :db,  "thebouldersocialclub.com", :primary => true
set :deploy_to, "/home/tyler/apps/deployed/#{application}"


#	Restart Passenger(mod_rails)
namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
after :deploy, "passenger:restart"

after "deploy:restart" do
  # symlink production db file
  run "rm -rf #{current_path}/db/production.sqlite3"
  run "ln -s  #{shared_path}/production.sqlite3 #{current_path}/db/production.sqlite3"
  # symlink production env
  run "rm -rf #{current_path}/config/environments/production.rb"
  run "ln -s  #{shared_path}/production.rb #{current_path}/config/environments/production.rb"
  # symlink sitekeys
  run "rm -rf #{current_path}/config/initializers/site_keys.rb"
  run "ln -s  #{shared_path}/site_keys.rb #{current_path}/config/initializers/site_keys.rb"
  # symlink event images
  run "rm -rf #{current_path}/public/events/"
  run "ln -s  #{shared_path}/events/ #{current_path}/public/events/"  
end
