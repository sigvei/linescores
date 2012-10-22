require 'bundler/capistrano'
set :application, "linescores"
set :repository,  "git@github.com:sigvei/linescores"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, :master
set :deploy_to, '/srv/virtualhosts/indregard.no/apps/linescores'
set :deploy_via, :remote_cache
set :use_sudo, false
set :user, Capistrano::CLI.ui.ask("Server username: ")
set :keep_releases, 3
ssh_options[:forward_agent] = true

set :rvm_ruby_string, 'ruby-1.9.3@linescores'

role :web, "indregard.no"                          # Your HTTP server, Apache/etc
role :app, "indregard.no"                          # This may be the same as your `Web` server
role :db,  "indregard.no", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

require 'rvm/capistrano'
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'

require 'capistrano-unicorn'
require './config/deploy/capistrano_database_yml'
