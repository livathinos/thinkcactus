require "test_helper"

class ArrayTest < ActiveSupport::TestCase

  should "verify to_hash_with" do
    keys, values = %w(a b c), %w(1 2 3)
    expected = { "a" => "1", "b" => "2", "c" => "3" }
    assert_equal expected, keys.to_hash_with(values)
  end

end
