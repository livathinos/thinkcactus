require 'test_helper'

class LoginTest < ActionController::IntegrationTest

  context "Admin goes to login page" do

    should "views page" do
      visit '/admin'
    end

  end

end
