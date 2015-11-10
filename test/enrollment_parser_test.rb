require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_parser'

class EnrollmentParserTest < Minitest::Test

  def setup
    @p = EnrollmentParser.new("./test/fixtures/sample_kindergarten.csv")
  end

  def test_parser_creates_array_of_one_hash_upon_initialization
    assert_equal Hash, @p.csv[0].class
  end

  def test_district_data_creates_keys_based_on_locations
    locations = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal locations, @p.district_data.keys
  end



 #  def test_districts_returns_array_of_values
 #    assert_equal [{:name=>"Colorado"},
 # {:name=>"ACADEMY 20"}], @p.districts
 #  end

end
