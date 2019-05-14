# README

Don't read ENV variables during runtime - read them once during startup.

App with messy setup made it hard to comprehend:
- does it use the dot-env file ENV variable?
- does it use the Docker ENV variable?
- does it use the server set ENV variable?
- what is the load order of initializers?

Don't add another dependency (that makes the app behave differently in dev & test vs production)

No need to set ENV variables in development (or test) that might be set in (Docker or the server) on the CI stage and the production stage.

## settings.rb

The file _config/settings.rb_ contains the (default) settings for development and test environment.

* Explain settings.rb
  * start with .register method only
  * mention where ENV variables could be set
  * mention settings.rb is loaded on the top of config/environment.rb
  * extract .set to demonstrate local overwrite
  * demonstrate different default values
  * explain reasoning for .is?
  * demonstrate .is?
  * show specs

## Overwrite settings locally

When you need to overwrite the default values, you have two options.

### settings.local.rb

Either add those lines to a _config/settings.local.rb_ file with the following syntax:

```ruby
Settings.set :db_username, "username_on_my_machine"
Settings.set :db_password, "password_on_my_machine"
```

### set ENV variables

This file is listed in _.gitignore_ so you won't accidentally publish your secrets.

Or you set ENV variables on your machine - like you would do on the production server or in a docker file:

```shell
export DB_USERNAME='username_on_my_machine'
export DB_PASSWORD='password_on_my_machine'
```

## How to use the values

Anywhere in your app call `Settings.db_username`.

If you have a typo here or try to access an un-registered variable, your app will raise a helpful error message:

```ruby
NoMethodError: undefined method 'dbu_sername' for Settings:Class
```

**Bonus:** the usage of configuration variable is easily grep-able

## Set values during runtime

In case the value of an ENV variable is not available during startup:

* `register` it without default value (it will contain `nil`)
* `set` the value once the information is available

## Settings vs Rails' Current vs Rails.application.configure

You could use

```ruby
Settings.register :global_variable
Settings.set, :global_variable, "my current value"
```

and effectively emulate Rails' `Current` functionality.

To ensure config keys are not registered twice, add a guard clause to the `register` method:

```ruby
  raise "Settings.#{var_name} has already been registered" if singleton_methods(false).include?(var_name)
```

> But it is strongly discouraged to use the `.set` method to change the value repeatedly at runtime. The Settings object should be used for configuration that is usually stable during the life-time of your app between boots.

It should therefore be compared to the `Rails.application.configure` mechanism. This is in fact similar. Though it uses `method_missing` and does therefore not complain about typos when trying to access a value.

And it is baked into Rails. You can not easily port it to your other non-Rails apps.
