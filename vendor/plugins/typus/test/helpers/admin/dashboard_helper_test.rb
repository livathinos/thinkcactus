require "test_helper"

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

  should "render resources" do
    current_user = Factory(:typus_user)
    output = resources(current_user)
    expected = ["admin/helpers/dashboard/resources", { :resources => ["Git", "Status", "WatchDog"] }]
    assert_equal expected, output
  end

end
