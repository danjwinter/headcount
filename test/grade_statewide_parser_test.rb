require 'minitest/autorun'
require 'minitest/pride'
require './lib/grade_statewide_parser'

class GradeStatewideParserTest < Minitest::Test

  def file_set_eighth_grade_statewide
      "./test/fixtures/sample_eighth_grade_CSAP.csv"
  end

  def setup
    @gsp = GradeStatewideParser.new
  end

  def load_path_1
    path1 = ["./test/fixtures/sample_third_grade_CSAP.csv", :third_grade]
    @gsp.load_info(path1)
  end

  def load_path_2
    path2 = ["./test/fixtures/sample_eighth_grade_CSAP.csv", :eighth_grade]
    @gsp.load_info(path2)
  end

  def test_parser_creates_array_of_empty_hash_upon_initialization
    assert_equal({},  @gsp.data_set)
  end

  def test_district_data_creates_keys_based_on_locations
    load_path_1
    locations = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal locations, @gsp.data_set.keys
  end

  def test_data_set_has_third_and_eight_grade_as_keys
    load_path_1
    load_path_2
    assert_equal [:third_grade, :eighth_grade], @gsp.data_set.first[1].keys
  end

  def test_grade_is_nil_upon_initialization
    assert_equal nil, @gsp.grade
  end

  def test_grade_changes_when_new_file_is_loaded
    load_path_1
    assert_equal :third_grade, @gsp.grade
    load_path_2
    assert_equal :eighth_grade, @gsp.grade
  end

  def attributes_stub
    [ {
      :location=>"Colorado",
      :score=>"Math",
      :timeframe=>"2008",
      :dataformat=>"Percent",
      :data=>"0.697"
      },
      {
      :location=>"Colorado",
      :score=>"Math",
      :timeframe=>"2009",
      :dataformat=>"Percent",
      :data=>"0.691"
      }
    ]
  end

  def test_year_prep_outputs_correct_years_from_attributes
    assert_equal({2008=>{:math=>0.697}, 2009=>{:math=>0.691}}, @gsp.year_prep(attributes_stub, year_data = {}))
  end

end
