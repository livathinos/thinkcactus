require "test_helper"

class ResourcesTest < ActiveSupport::TestCase

  should "verify default resource configuration options" do
    assert_equal "edit", Typus::Resources.action_after_save
    assert_equal "edit", Typus::Resources.default_action_on_item
    assert_nil Typus::Resources.end_year
    assert_equal 15, Typus::Resources.form_rows
    assert_equal "nil", Typus::Resources.human_nil
    assert_equal 5, Typus::Resources.minute_step
    assert !Typus::Resources.only_user_items
    assert_equal 15, Typus::Resources.per_page
    assert Typus::Resources.sortable
    assert_nil Typus::Resources.start_year
  end

end
