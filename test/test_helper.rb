ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper

  # Returns true if a test user is logged in.
  def is_logged_in?
    session[:user_id].present?
  end
end
