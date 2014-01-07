class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper # the functions that manage session-controlled sign-in
  # helpers are automatically available in views, but not in controllers. That's why we need thios inclusion here!
  
end
