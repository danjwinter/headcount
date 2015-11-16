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

  def test_data_set_is_empty_when_class_is_instantiated
    assert_equal({}, @rsp.data_set)
  end

  def test_subject_is_nil_upon_instantiation
    assert_equal nil, @rsp.subject
  end

  def test_subject_gets_pulled_when_loading_file_set
    @rsp.load_info([file_set_math_statewide, :math])
    assert_equal :math, @rsp.subject
  end

  def test_subject_changes_with_new_file_set
    @rsp.load_info([file_set_math_statewide, :math])
    assert_equal :math, @rsp.subject
    @rsp.load_info([file_set_reading_statewide, :reading])
    assert_equal :reading, @rsp.subject
    @rsp.load_info([file_set_writing_statewide, :writing])
    assert_equal :writing, @rsp.subject
  end

  def test_grouped_data_by_district_names_keys_are_district_names
    @rsp.load_info([file_set_math_statewide, :math])
    districts = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    upcased_keys_grouped_district_data = @rsp.grouped_data_by_district_name.keys.map {|district| district.upcase}
    assert_equal districts, upcased_keys_grouped_district_data
  end

  def csv_stub
    [{:location=>"Colorado", :race_ethnicity=>"All Students", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.5573"},
 {:location=>"Colorado", :race_ethnicity=>"Asian", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.7094"},
 {:location=>"Colorado", :race_ethnicity=>"Black", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.3333"},
 {:location=>"Colorado", :race_ethnicity=>"Hawaiian/Pacific Islander", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.541"},
 {:location=>"Colorado", :race_ethnicity=>"Hispanic", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.3926"},
 {:location=>"Colorado", :race_ethnicity=>"Native American", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.3981"},
 {:location=>"Colorado", :race_ethnicity=>"Two or more", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.6101"},
 {:location=>"Colorado", :race_ethnicity=>"White", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.6585"}]
 end

  def test_races_and_dates_are_collected
    races = []
    dates = []
    @rsp.csv = csv_stub
    @rsp.collect_races_and_dates(races, dates)
    collected_races = [:all_students, :asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    collected_dates = [2011, 2012]
    assert_equal collected_races, races.uniq
    assert_equal collected_dates, dates.uniq
  end

  def test_date_setup_sets_up_dates
    expected_date_setup = {1969 => {math: nil, reading: nil, writing: nil},
                           1412 => {math: nil, reading: nil, writing: nil}}
    assert_equal expected_date_setup,@rsp.date_setup([1969, 1412])
  end

  def test_load_info_retrieves_asian_math_data
    @rsp.load_info([file_set_math_statewide, :math])
    @rsp.load_info([file_set_reading_statewide, :reading])
    @rsp.load_info([file_set_writing_statewide, :writing])

    assert_equal 0.8169, @rsp.data_set["ACADEMY 20"][:asian][2011][:math]
    assert_equal 0.8182, @rsp.data_set["ACADEMY 20"][:asian][2012][:math]
  end

  def test_load_info_retrieves_black_math_data
    @rsp.load_info([file_set_math_statewide, :math])
    @rsp.load_info([file_set_reading_statewide, :reading])
    @rsp.load_info([file_set_writing_statewide, :writing])

    assert_equal 0.2252, @rsp.data_set["ADAMS COUNTY 14"][:black][2012][:math]
    assert_equal 0.1961, @rsp.data_set["ADAMS COUNTY 14"][:black][2011][:math]
  end

  def test_load_info_retrieves_hispanic_reading_data
    @rsp.load_info([file_set_math_statewide, :math])
    @rsp.load_info([file_set_reading_statewide, :reading])
    @rsp.load_info([file_set_writing_statewide, :writing])

    assert_equal 0.41874, @rsp.data_set["ADAMS COUNTY 14"][:hispanic][2012][:reading]
    assert_equal 0.4341, @rsp.data_set["ADAMS COUNTY 14"][:hispanic][2011][:reading]
  end

  def test_load_info_retrieves_pacific_islander_writing_data
    @rsp.load_info([file_set_math_statewide, :math])
    @rsp.load_info([file_set_reading_statewide, :reading])
    @rsp.load_info([file_set_writing_statewide, :writing])

    assert_equal 0.3564, @rsp.data_set["ADAMS-ARAPAHOE 28J"][:pacific_islander][2012][:writing]
    assert_equal 0.3529, @rsp.data_set["ADAMS-ARAPAHOE 28J"][:pacific_islander][2011][:writing]
  end

  def test_district_data_creates_keys_based_on_locations
      @rsp.load_info([file_set_math_statewide, :math])
    locations = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal locations, @rsp.data_set.keys
  end

end
