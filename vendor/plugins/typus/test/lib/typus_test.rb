require "test_helper"

class TypusTest < ActiveSupport::TestCase

  should "verify default_config for admin_title" do
    assert_equal "Typus", Typus.admin_title
  end

  should "verify default_config for admin_sub_title" do
    assert Typus.admin_sub_title.kind_of?(String)
  end

  should "verify default_config for authentication" do
    assert_equal :session, Typus.authentication
  end

  should "verify default_config for mailer_sender" do
    assert_nil Typus.mailer_sender
  end

  should "verify default_config for username" do
    assert_equal "admin", Typus.username
  end

  should "verify default_config for password" do
    assert_equal "columbia", Typus.password
  end

  should "verify default_config for file_preview" do
    assert_equal :medium, Typus.file_preview
  end

  should "verify default_config for file_thumbnail" do
    assert_equal :thumb, Typus.file_thumbnail
  end

  should "verify default_config for relationship" do
    assert_equal "typus_users", Typus.relationship
  end

  should "verify default_config for master_role" do
    assert_equal "admin", Typus.master_role
  end

  should "verify default_config for user_class_name" do
    assert_equal "TypusUser", Typus.user_class_name
  end

  should "verify default_config for typus_user_id" do
    assert_equal "typus_user_id", Typus.user_fk
  end

  should "verify default_config for available_locales" do
    assert_equal [:en], Typus.available_locales
  end

  should "verify config_folder is a Pathname" do
    assert Typus.config_folder.kind_of?(Pathname)
  end

  should "return root" do
    expected = "."
    assert Typus.root.kind_of?(String)
    assert_equal expected, Typus.root
  end

  should "return applications sorted" do
    assert Typus.respond_to?(:applications)
    assert Typus.applications.kind_of?(Array)
    assert_equal %w(Blog Site Typus), Typus.applications
  end

  should "return modules of an application" do
    assert Typus.respond_to?(:application)
    assert_equal %w(Comment Picture Post), Typus.application("Blog")
  end

  should "return models and should be sorted" do
    assert Typus.respond_to?(:models)
    assert Typus.models.kind_of?(Array)
    assert_equal %w(Asset Category Comment CustomUser Page Picture Post TypusUser View), Typus.models
  end

  should "verify resources class_method" do
    assert Typus.respond_to?(:resources)
    assert_equal %w(Git Order Status WatchDog), Typus.resources
  end

  should "return user_class" do
    assert_equal TypusUser, Typus.user_class
  end

  should "return overrided user_class" do
    Typus.expects(:user_class_name).returns("CustomUser")
    assert_equal CustomUser, Typus.user_class
  end

  should "return_user_fk" do
    assert_equal "typus_user_id", Typus.user_fk
  end

  should "return overrided user_fk" do
    Typus.expects(:user_fk).returns("my_user_fk")
    assert_equal "my_user_fk", Typus.user_fk
  end

end
