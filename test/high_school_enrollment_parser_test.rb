require 'minitest/autorun'
require 'minitest/pride'
require './lib/high_school_enrollment_parser'

class HighSchoolEnrollmentParserTest < Minitest::Test

  def file_set_high_school
      "./test/fixtures/sample_high_school.csv"
  end

  def raw_high_grad_data
    [{:location=>"ADAMS COUNTY 14", :timeframe=>"2010", :dataformat=>"Percent", :data=>"0.57"},
   {:location=>"ADAMS COUNTY 14", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.608"},
   {:location=>"ADAMS COUNTY 14", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.63372"}]
  end

  def academy_20_parsed_district_data
    {:name=>"ACADEMY 20", :high_school_graduation=>{2010=>0.895, 2011=>0.895, 2012=>0.88983}}
  end

  def setup
    @hsep = HighSchoolEnrollmentParser.new(file_set_high_school)
  end

  def test_parser_creates_array_of_one_hash_upon_initialization
    assert_equal Hash, @hsep.csv[0].class
  end

  def test_district_data_creates_keys_based_on_locations
    locations = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal locations, @hsep.district_data.keys
  end

  def test_district_data_prints_value
    stats1 = ({2010=>0.724, 2011=>0.739, 2012=>0.75354})
    assert_equal({:name=>"COLORADO", :high_school_graduation => stats1}, @hsep.district_data.first[1])
    assert_equal academy_20_parsed_district_data, @hsep.district_data.fetch("ACADEMY 20")
  end

  # CHECK TEST NAME
  def test_high_school_graduation_prep_returns_high_grad_data
    assert_equal({2010=>0.57, 2011=>0.608, 2012=>0.63372}, @hsep.high_school_graduation_prep(raw_high_grad_data))
  end

end
