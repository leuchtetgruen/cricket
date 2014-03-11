Recaptcha.configure do |config|
  config.public_key  = Settings.captcha.public_key
  config.private_key = Settings.captcha.private_key
end