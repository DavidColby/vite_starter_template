require "fileutils"
require "shellwords"
require 'pry'

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("vite-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/davidcolby/vite_template.git",
      tempdir
    ].map(&:shellescape).join(" ")
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def prevent_webpack_conflicts
  self.options = options.merge(skip_webpack_install: true).freeze
end

def add_gems
  gem 'stimulus_reflex', github: 'stimulusreflex/stimulus_reflex', branch: 'master'
  gem 'turbo-rails'
  gem 'vite_rails'
  gsub_file 'Gemfile', /^\s*# gem 'redis'.*/, "gem 'redis'"
  gsub_file 'Gemfile', /^\s*gem 'webpacker'.*\n/, ''
  gsub_file 'Gemfile', /^\s*gem 'spring'.*\n/, ''
  gsub_file 'Gemfile', /^\s*gem 'turbolinks'.*\n/, ''
  gsub_file 'Gemfile', /^\s*gem 'jbuilder'.*\n/, ''
end

def set_application_name
  environment "config.application_name = Rails.application.class.module_parent_name"
end

def install_vite
  run "vite install"
  run "rm -f package-lock.json"
end

def setup_vite
  run 'yarn add -D vite-plugin-full-reload vite-plugin-stimulus-hmr'
  run 'yarn add @rails/actioncable stimulus @hotwired/turbo-rails cable_ready stimulus-vite-helpers stimulus_reflex vite-plugin-windicss windicss'
  copy_file 'vite.config.ts', force: true
  remove_file 'app/assets/stylesheets/application.css'
  directory 'app', force: true
end

def setup_windicss
  copy_file 'tailwind.config.ts'
end

def setup_stimulusreflex
  rails_command 'dev:cache'
  environment "config.session_store :cache_store, key: '_sessions_development', compress: true, pool_size: 5, expire_after: 1.year", env: 'development'
  gsub_file 'config/environments/development.rb', 'config.cache_store = :memory_store', 'config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }'
  gsub_file 'config/cable.yml', 'adapter: async', "adapter: redis\n  url: <%= ENV.fetch('REDIS_URL') { 'redis://localhost:6379/1' } %>\n  channel_prefix: #{@app_name.underscore}"
end

prevent_webpack_conflicts
add_template_repository_to_source_path
add_gems

after_bundle do
  set_application_name
  install_vite
  setup_vite
  setup_windicss
  setup_stimulusreflex
  unless ENV["SKIP_GIT"]
    git :init
    git add: "."
    begin
      git commit: %( -m 'Initial commit' )
    rescue StandardError => e
      puts e.message
    end
  end
  say
  say "Vite Rails app successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "  rails db:create db:migrate"
  say "  bin/vite dev"
  say "  rails s"
end
