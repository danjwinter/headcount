require 'minitest/autorun'
require 'minitest/pride'
require './lib/race_statewide_parser'

class RaceStatewideParserTest < Minitest::Test

  def file_set_math_statewide
      "./test/fixtures/sample_statewide_math.csv"
  end

  def file_set_reading_statewide
      "./test/fixtures/sample_statewide_reading.csv"
  end

  def file_set_writing_statewide
      "./test/fixtures/sample_statewide_writing.csv"
  end

  def setup
    @rsp = RaceStatewideParser.new
  end

  def asian_opts
    {2008=> {:math => 0.469, :reading => 0.703, :writing => 0.529},
    2009=>{:math => 0.499, :reading => 0.726, :writing => 0.528},
    2010=>{:math => 0.51, :reading => 0.679, :writing => 0.549}}
  end

  def test_load_info_retrieves_asian_data
    @rsp.load_info([file_set_math_statewide, :math])
    @rsp.district_data
    @rsp.load_info([file_set_reading_statewide, :reading])
    @rsp.district_data
    @rsp.load_info([file_set_writing_statewide, :writing])
    @rsp.district_data
    binding.pry
    # assert_equal asian_opts, @rsp.proficient_by_race_or_ethnicity(:asian)
  end


  def test_parser_creates_array_of_one_hash_upon_initialization
    skip
    assert_equal Hash, @rsp.csv[0].class
  end

  def test_district_data_creates_keys_based_on_locations
    skip
    locations = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal locations, @rsp.district_data.keys
  end

  def test_district_data_prints_value
    skip
    stats1 = ({2008=> {:math => 0.469, :reading => 0.703, :writing => 0.529},
    2009=>{:math => 0.499, :reading => 0.726, :writing => 0.528},
    2010=>{:math => 0.51, :reading => 0.679, :writing => 0.549}})
    assert_equal({:name=>"COLORADO", :eighth_grade => stats1}, @rsp.district_data.first[1])
    # assert_equal academy_20_parsed_district_data, @rsp.district_data.fetch("ACADEMY 20")
  end

end
