# RAILS_ROOT/xxx/example.rb

class Example
  def some_method
    # ...

    send_mail(from: Settings.mail_from, body: body)

    # ...
  end
end
