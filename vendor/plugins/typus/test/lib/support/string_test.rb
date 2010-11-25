require "test_helper"

class StringTest < ActiveSupport::TestCase

  should "extract_settings" do
    assert_equal %w( a b c ), "a, b, c".extract_settings
    assert_equal %w( a b c ), " a  , b,  c ".extract_settings
  end

  context "remove_prefix" do

    should "remove admin by default" do
      assert_equal "posts", "admin/posts".remove_prefix
      assert_equal "typus_users", "admin/typus_users".remove_prefix
      assert_equal "delayed/jobs", "admin/delayed/jobs".remove_prefix
    end

    should "remove what we want to" do
      assert_equal "posts", "typus/posts".remove_prefix("typus/")
      assert_equal "typus_users", "typus/typus_users".remove_prefix("typus/")
      assert_equal "delayed/tasks", "typus/delayed/tasks".remove_prefix("typus/")
    end

  end

  context "extract_class" do

    should "work for models" do
      assert_equal Post, "admin/posts".extract_class
      assert_equal TypusUser, "admin/typus_users".extract_class
    end

    should "work for namespaced models" do
      assert_equal Delayed::Task, "admin/delayed/tasks".extract_class
    end

    should "work with inflections" do
      assert_equal SucursalBancaria, "admin/sucursales_bancarias".extract_class
    end

  end

end
