require "test_helper"

class Admin::FiltersHelperTest < ActiveSupport::TestCase

  include Admin::FiltersHelper

  should "build_filters"

  should "relationship_filter"

  context "date_filter" do

    should "return an array" do
      output = date_filter("request", "filter")
      expected = "filter",
                 [["Today", "today"], ["Last few days", "last_few_days"], ["Last 7 days", "last_7_days"], ["Last 30 days", "last_30_days"]],
                 "Show all dates"
      assert_equal expected, output
    end

  end

  context "boolean_filter" do

    setup do
      @resource = Post
    end

    should "return an array" do
      output = boolean_filter("request", "filter")
      expected = "filter",
                 {"True"=>"true", "False"=>"false"},
                 "Show by filter"
      assert_equal expected, output
    end

  end

  context "string_filter" do

    setup do
      @resource = Post
    end

    should "return an array" do
      output = string_filter("request", "status")
      expected = "status",
                 {"unpublished"=>"unpublished", "pending"=>"pending", "published"=>"published"},
                 "Show by status"
      assert_equal expected, output
    end

  end

  context "remove_filter_link" do

    should "return nil when blank" do
      output = remove_filter_link("", {})
      assert_nil output
    end

    should "return link to remove search" do
      output = remove_filter_link('test', {:search => 'test'})
      expected = ["Remove search"]
      assert_equal expected, output
    end

    should "return link to remove filter" do
      output = remove_filter_link('test', {:filter => 'test'})
      expected = ["Remove filter"]
      assert_equal expected, output
    end

  end

  def link_to(*args); args; end

end
