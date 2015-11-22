# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'qaa'
set :repo_url, 'git@github.com:webmstk/qaa.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qaa'
set :deploy_user, 'deployer'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', 'config/private_pub_thin.yml', '.env')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# how to restart
# set :passenger_restart_with_touch, false # passenger-config restart-app
set :passenger_restart_with_touch, true # touch tmp/restart.txt

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml restart'
        end
      end
    end
  end
end

namespace :thinking_sphinx do
  desc 'Index thinking sphinx'
  task :index do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'RAILS_ENV=production ts:index'
        end
      end
    end
  end

  desc 'Start thinking sphinx'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'RAILS_ENV=production ts:start'
        end
      end
    end
  end

  desc 'Stop thinking sphinx'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'RAILS_ENV=production ts:stop'
        end
      end
    end
  end

  desc 'Rebuild thinking sphinx'
  task :rebuild do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'RAILS_ENV=production ts:rebuild'
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:stop'
after 'deploy:restart', 'private_pub:start'
after 'deploy:restart', 'thinking_sphinx:index'
after 'deploy:restart', 'thinking_sphinx:stop'
after 'deploy:restart', 'thinking_sphinx:start'