# RAILS_ROOT/config/environment.rb
#
# Loading the Settings class on the very top,
#   means it is available in Rails' config files
#
#   --> config/environments/development.rb
#
#   --> config.action_mailer.default_url_options = {
#         host: Settings.host, port: Settings.port }
#
# and no ENV variables have to be used directly
#
require_relative "settings"

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
