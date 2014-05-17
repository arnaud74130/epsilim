require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module Epsilim
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
     config.i18n.enforce_available_locales = true
     config.i18n.default_locale = :fr

     #config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"] # aga: approach: only works if you are loading a class that defined only in "ONE" place. If some class has been already defined somewhere else, then you can't load it again by this approach.

     config.assets.paths << "#{Rails}/vendor/assets/fonts"
     
     ROLES = [:direction, :cp, :ro]
     ROLE_METHODS = 1.upto(ROLES.size).flat_map do |n|
    ROLES.permutation(n).map {|vs| vs.join("_") }
 end
  end
end
