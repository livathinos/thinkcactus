set :application, "thinkcactus"
  set :user, "spiros"
  set :use_sudo, false

  set :repository,  "https://spyros_l:poioseinai@bitbucket.org/spyros_l/thinkcactus"
  set :deploy_to, "/web/#{application}"
  set :scm, :mercurial

  set :port, 2269                      # The port you've setup in the SSH setup section
  set :location, "ceidtrip.tk"
  role :app, location
  role :web, location
  role :db,  location, :primary => true

  namespace :deploy do
    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
    end

    desc "Make symlink for database.yml" 
    task :symlink_dbyaml do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
    end

    desc "Create empty database.yml in shared path" 
    task :create_dbyaml do
      run "mkdir -p #{shared_path}/config" 
      put '', "#{shared_path}/config/database.yml" 
    end

    desc "Make symlink for s3.yml" 
    task :symlink_s3yaml do
      run "ln -nfs #{shared_path}/config/s3.yml #{release_path}/config/s3.yml" 
    end

    desc "Create empty s3.yml in shared path" 
    task :create_s3yaml do
      run "mkdir -p #{shared_path}/config" 
      put '', "#{shared_path}/config/s3.yml" 
    end

    desc "Make symlink for billing_on_rails.yml" 
    task :symlink_billingyaml do
      run "ln -nfs #{shared_path}/config/billing_on_rails.yml #{release_path}/config/billing_on_rails.yml" 
    end

    desc "Create empty billing_on_rails.yml in shared path" 
    task :create_billingyaml do
      run "mkdir -p #{shared_path}/config" 
      put '', "#{shared_path}/config/billing_on_rails.yml" 
    end
  end

  after 'deploy:setup', 'deploy:create_dbyaml'
  after 'deploy:update_code', 'deploy:symlink_dbyaml'

  after 'deploy:setup', 'deploy:create_s3yaml'
  after 'deploy:update_code', 'deploy:symlink_s3yaml'

  after 'deploy:setup', 'deploy:create_billingyaml'
  after 'deploy:update_code', 'deploy:symlink_billingyaml'

  after "deploy", "deploy:cleanup"