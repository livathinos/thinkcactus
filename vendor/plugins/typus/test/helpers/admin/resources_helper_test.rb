require "test_helper"

class Admin::ResourcesHelperTest < ActiveSupport::TestCase

  include Admin::ResourcesHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def render(*args); args; end

  context "display_link_to_previous" do

    should "verify display_link_to_previous" do
      @resource = Post
      params = { :action => "edit", :back_to => "/back_to_param" }
      self.expects(:params).at_least_once.returns(params)

      expected = [ "admin/helpers/resources/display_link_to_previous", { :message => "You're updating a Post." } ]
      output = display_link_to_previous

      assert_equal expected, output
    end
  end

  context "build_list" do

    setup do
      @model = TypusUser
      @fields = %w( email role status )
      @items = TypusUser.all
      @resource = "typus_users"
    end

    should "return a table" do
      expected = [ "admin/typus_users/list", { :items => [] } ]
      output = build_list(@model, @fields, @items, @resource)
      assert_equal expected, output
    end

    should "return a template" do
      self.stubs(:render).returns("a_template")
      File.stubs(:exist?).returns(true)

      expected = "a_template"
      output = build_list(@model, @fields, @items, @resource)

      assert_equal expected, output
    end

  end

end
