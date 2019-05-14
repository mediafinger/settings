# Settings

A clean way to handle **custom configuration values**

In any Ruby app (not only Rails)

And without using `method-missing`

---
## Convoluted custom configuration chaos

---
### What's the value when and why?

* does it use the dot-env file ENV variable?
* does it use the Docker ENV variable?
* does it use the server set ENV variable?
* what is the load order of initializers?

---
## Don't use ENV in your apps directly

* rely on configuration values set in your code
* don't fail silently on typos
* use default values
* use objects, not only strings

---
## No external dependency

* setting values is simple
* no need to add another gem to your codebase
* use the same mechanism regardless of the environment

---
## Everything in one file

* keep the overview
* understand the mechanism
* add custom methods easily
* load it before anything else

---
### Implementation

There is not much code to show, so I will show it.

---
#### Settings.register

```ruby
# class Settings
#
def self.register(var_name)
  define_singleton_method(var_name) {
    instance_variable_get("@#{var_name}")
  }

  instance_variable_set("@#{var_name}",
    ENV.fetch(var_name.to_s.upcase)
end
```

---
#### Settings.register with default value

```ruby
# class Settings
#
def self.register(var_name, default: nil)
  define_singleton_method(var_name) {
    instance_variable_get("@#{var_name}")
  }

  instance_variable_set("@#{var_name}",
    ENV.fetch(var_name.to_s.upcase, default))
end
```

---
#### Settings.register usage

```ruby
# Set custom configuration variable with default:
#
# uses default unless ENV["API_URL"] is set
#
register :api_url, default: "http://localhost:4567/api"

# Access:
#
Settings.api.url
```

---
#### Settings.register with default value

```ruby
# class Settings
#
def self.register(var_name, default: nil)
  define_singleton_method(var_name) {
    instance_variable_get("@#{var_name}")
  }

  instance_variable_set("@#{var_name}",
    ENV.fetch(var_name.to_s.upcase, default))
end
```

---
#### Settings.set extracted

```ruby
# class Settings
#
def self.register(var_name, default: nil)
  define_singleton_method(var_name) {
    instance_variable_get("@#{var_name}")
  }

  set(var_name, ENV.fetch(var_name.to_s.upcase, default))
end

def self.set(var_name, value)
  instance_variable_set("@#{var_name}", value)
end
```

---
#### Settings.set usage

```ruby
# overwrite registered variables:
#
Settings.set :access_locked, true
```

---
## Avoid comparison bugs

---
### Do you spot the classic error?

```ruby
if ENV["PRINT_STACKTRACE"]
  # ...
```

---
### What if...?

```shell
export PRINT_STACKTRACE=false
```

---
### Type agnostic comparison method

```ruby
def self.is?(var_name, other_value)
  public_send(var_name.to_sym).to_s == other_value.to_s
end
```

```ruby
if Settings.is?(:print_stacktrace, true)
  # ...
```

---
## ~~Convoluted custom configuration chaos~~

---
@transition[fade]

## Consistent concise custom configuration

---
## Consistent concise custom configuration

* all custom configuration values are declared in one file
* the code is easily grep-able for their usage
* load order is clear
* use the same mechanism regardless of the framework

---
## Code examples

---
## Thank you

Find this presentation

a README with similar content

and several `code` examples

under: **https://github.com/mediafinger/settings**

### Andreas Finger &nbsp;&nbsp;&nbsp; @mediafinger
