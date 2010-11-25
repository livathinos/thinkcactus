# coding: utf-8

require "test_helper"

class Admin::SidebarHelperTest < ActiveSupport::TestCase

  include Admin::SidebarHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper

  def render(*args); args; end

  setup do
    default_url_options[:host] = 'test.host'
  end

  should "test_actions"

  should_eventually "test_export" do
    @resource = Post

    params = { :controller => '/admin/posts', :action => 'index' }
    self.expects(:params).at_least_once.returns(params)
    output = export
    expected = [ "admin/helpers/list", { :items => [ %(<a href="http://test.host/admin/posts?format=csv">CSV</a>),
                                                     %(<a href="http://test.host/admin/posts?format=xml">XML</a>) ],
                                         :header => "Export",
                                         :options => { :header => "export" } } ]

    assert_equal expected, output
  end

  should_eventually "test_build_typus_list_with_empty_content_and_empty_header" do
    output = build_typus_list([], :header => nil)
    assert output.empty?
  end

  should_eventually "test_build_typus_list_with_content_and_header" do
    output = build_typus_list(['item1', 'item2'], :header => "Chunky Bacon")
    assert !output.empty?

    expected = [ "admin/helpers/list", { :header=>"Chunky bacon",
                                         :options => { :header => "Chunky Bacon" },
                                         :items => [ "item1", "item2" ] } ]

    assert_equal expected, output
  end

  should_eventually "test_build_typus_list_with_content_without_header" do
    output = build_typus_list(['item1', 'item2'])
    expected = [ "admin/helpers/list", { :header => nil,
                                         :options => {},
                                         :items=>["item1", "item2"] } ]
    assert_equal expected, output
  end

  should_eventually "test_search" do

    @resource = TypusUser

    params = { :controller => '/admin/typus_users', :action => 'index' }
    self.expects(:params).at_least_once.returns(params)

    output = search

    partial = "admin/helpers/search"
    options = { :hidden_params => [ %(<input id="action" name="action" type="hidden" value="index" />),
                                    %(<input id="controller" name="controller" type="hidden" value="admin/typus_users" />) ],
                :search_by => "First name, Last name, Email, and Role" }

    assert_equal partial, output.first

    output.last[:hidden_params].each do |o|
      assert options[:hidden_params].include?(o)
    end
    assert options[:search_by].eql?(output.last[:search_by])

  end

  should_eventually "test_filters" do
    @resource = TypusUser
    @resource.expects(:typus_filters).returns(Array.new)
    output = filters
    assert output.nil?
  end

  should "test_filters_with_filters"

end
