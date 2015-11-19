require 'minitest/autorun'
require 'minitest/pride'
require './lib/kindergarten_enrollment_parser'

class KindergartenEnrollmentParserTest < Minitest::Test

  def file_set_kindergarten
      "./test/fixtures/sample_kindergarten.csv"
  end

  def raw_kind_prep_data
    [
    {:location=>"ADAMS COUNTY 14", :timeframe=>"2007", :dataformat=>"Percent", :data=>"0.30643"},
    {:location=>"ADAMS COUNTY 14", :timeframe=>"2006", :dataformat=>"Percent", :data=>"0.29331"},
    {:location=>"ADAMS COUNTY 14", :timeframe=>"2005", :dataformat=>"Percent", :data=>"0.3"}
    ]
  end

  def academy_20_parsed_district_data
    {:name=>"ACADEMY 20", :kindergarten_participation=>{2007=>0.39159, 2006=>0.35364, 2005=>0.26709}}
  end

  def setup
    @ep = KindergartenEnrollmentParser.new(file_set_kindergarten)
  end

  def test_parser_creates_array_of_one_hash_upon_initialization
    assert_equal Hash, @ep.csv[0].class
  end

  def test_district_data_creates_keys_based_on_locations
    locations = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal locations, @ep.district_data.keys
  end

  def test_district_data_prints_value
    stats1 = ({2007=>0.39465, 2006=>0.33677, 2005=>0.27807})
    assert_equal({:name=>"Colorado", :kindergarten_participation => stats1}, @ep.district_data.first[1])
    assert_equal academy_20_parsed_district_data, @ep.district_data.fetch("ACADEMY 20")
  end

  def test_kindergarten_participation_prep_returns_kind_par_data
    assert_equal({2007=>0.30643, 2006=>0.29331, 2005=>0.3}, @ep.kindergarten_participation_prep(raw_kind_prep_data))
  end

end
