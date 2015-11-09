require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district'

class DistrictTest < Minitest::Test

  def setup
    @d1 = District.new({:name => "ACADEMY 20"})
    @d2 = District.new({:name => "Colorado"})
  end

  def test_class_exists
    assert @d1
  end

  def test_data_is_stored_as_an_instance_variable
    assert_equal({:name => "ACADEMY 20"}, @d1.data)
  end

  def test_name_returns_upcased_string_of_district
    assert_equal "ACADEMY 20", @d1.name
    assert_equal "COLORADO", @d2.name
  end

  def test_name_is_not_still_lowercase
    refute_equal "Colorado", @d2.name
    refute_equal "Academy 20", @d1.name
  end


end
