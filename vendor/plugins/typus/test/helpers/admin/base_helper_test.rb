require "test_helper"

class Admin::BaseHelperTest < ActiveSupport::TestCase

  include Admin::BaseHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end
  # include ActionView::Rendering
  # include ActionView::Partials

  context "login info" do

    setup do
      current_user = mock
      self.stubs(:current_user).returns(current_user)
      current_user.stubs(:name).returns("Admin")
      current_user.stubs(:id).returns(1)
    end

    should "skip rendering when we're using a fake user" do
      current_user.stubs(:is_a?).with(FakeUser).returns(true)
      output = login_info
      assert_nil output
    end

    context "when the current user is not a FakeUser" do

      setup do
        current_user.stubs(:is_a?).with(FakeUser).returns(false)
        @partial = "admin/helpers/login_info"
        @default_message =  "Are you sure you want to sign out and end your session?"
      end

      context "when the user cannot edit his informations" do

        should "render a partial with the user name" do
          current_user.stubs(:can?).with('edit', 'TypusUser').returns(false)

          output = login_info
          options = {:user_details => "Admin", :message => @default_message}

          assert_equal [@partial, options], output
        end

      end

      context "when the user can edit his informations" do

        should "render a partial with a link" do
          link_options = { :action => 'edit', :controller => '/admin/typus_users', :id => 1 }

          current_user.stubs(:can?).with('edit', 'TypusUser').returns(true)
          self.stubs(:link_to).with("Admin", link_options).returns(%(<a href="/admin/typus_users/edit/1">Admin</a>))

          output = login_info
          options = { :user_details => %(<a href="/admin/typus_users/edit/1">Admin</a>),
                      :message => @default_message }

          assert_equal [@partial, options], output
        end

      end

    end

  end

  context "header" do

    should_eventually "render with root_path" do

      # ActionView::Helpers::UrlHelper does not support strings, which are 
      # returned by named routes link root_path
      self.stubs(:link_to).returns(%(<a href="/">View site</a>))
      self.stubs(:link_to_unless_current).returns(%(<a href="/admin/dashboard">Dashboard</a>))

      output = header

      partial = "admin/helpers/header"
      options = { :links => [ %(<a href="/admin/dashboard">Dashboard</a>),
                              %(<a href="/admin/dashboard">Dashboard</a>),
                              %(<a href="/">View site</a>) ] }

      assert_equal [ partial, options ], output

    end

    should_eventually "render without root_path" do

      Rails.application.routes.named_routes.routes.reject! { |key, route| key == :root }

      self.stubs(:link_to_unless_current).returns(%(<a href="/admin/dashboard">Dashboard</a>))

      output = header
      partial = "admin/helpers/header"
      options = { :links => [ %(<a href="/admin/dashboard">Dashboard</a>),
                              %(<a href="/admin/dashboard">Dashboard</a>) ] }

      assert_equal [ partial, options ], output

    end

  end

  context "display_flash_message" do

    should "be displayed" do
      message = { :test => "This is the message." }
      output = display_flash_message(message)
      expected = ["admin/helpers/flash_message",
                  { :flash_type => :test, :message => { :test => "This is the message." } }]
      assert_equal expected, output
    end

    should "not be displayed when message is empty" do
      assert_nil display_flash_message(Hash.new)
    end

  end

end
