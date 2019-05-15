# RAILS_ROOT/config/settings.rb

# Instead of using ENV variables in the code,
#   read them at startup and store them in this Settings object.
#
# This allows to:
# - work with default values
# - see all keys of externaly set values in one file
# - ensure that typos in the variable names are detected at 'compile' time
# - overwrite values in config/settings.xxx.rb file(s)
# - compare values type agnostic with the `.is?` method
# - not add another dependency

class Settings
  # sets class instance variable with given name and value
  #
  def self.set(var_name, value)
    instance_variable_set("@#{var_name}", value)
  end

  # creates getter method that reads the class instance variable with given name
  #   sets value from ENV variable
  #   or `default` value
  #
  def self.register(var_name, default: nil)
    define_singleton_method(var_name) { instance_variable_get("@#{var_name}") }
    set(var_name, ENV.fetch(var_name.to_s.upcase, default))
  end

  # to compare a setting vs a value and 'ignore' type, no more Boolean or Number mis-comparisons
  #
  def self.is?(var_name, other_value)
    public_send(var_name.to_sym).to_s == other_value.to_s
  end


  # WiFi credentials
  register :wifi_name,     default: "XING-GUEST"
  register :wifi_password, default: "goxinggo"


  # API credentials
  register :api_base_url, default: "https://example.com/api"
  register :api_username, default: "development"
  register :api_password, default: "not_secret"


  ##################################################################################
  #
  # Don't add secrets as 'default' values here!
  #
  # Either set ENV vars for secrets
  #   or add them to this file, which should be in .gitignore:
  #
  load "config/settings.local.rb" if File.exist?("config/settings.local.rb")
  #
  # inside use this syntax:
  #
  # Settings.set :password, "secret"

  #################################################################################
  #
  # When used with Rails, you could load files with environment specific settings
  #
  # load "config/settings.#{Rails.env}.rb" if File.exist?("config/settings.#{Rails.env}.rb")
  #
  # The recommendation is to register all variables in the general file
  #   and only set (= overwrite) environment specific values in these additional files
  #
  # Settings.set :api_base_url, "http://staging.example.com/api"
end
