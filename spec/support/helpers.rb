# frozen_string_literal: true

def show_page
  save_page Rails.root.join( "public", "capybara.html" )
  %x(launchy http://localhost:3000/capybara.html)
end

def sign_in email_or_object, password: nil, raise_if_failed: true
  if email_or_object.respond_to? :email
    email = email_or_object.email
    password = email_or_object.password
  else
    email = email_or_object
  end

  visit "/admin"

  fill_in :admin_user_email, with: email
  fill_in :admin_user_password, with: password

  click_button "inloggen"

  raise if raise_if_failed && !has_notice?("Je bent succesvol ingelogd.")
end

def saop
  save_and_open_page
end

def has_notice?(message)
  Page::FlashMessage.new(:notice, message).exists?
end

def has_alert?(message)
  Page::FlashMessage.new(:alert, message).exists?
end
