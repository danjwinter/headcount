require 'minitest/autorun'
require 'minitest/pride'
require './lib/parser_repository'
require 'pry'

class ParserRepositoryTest < Minitest::Test

  def file_set
    {
      :enrollment => {
      :kindergarten => "./test/fixtures/sample_kindergarten.csv",
      :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
    }
  end

  def file_set_2
    {
      :statewide_testing => {
      :third_grade => "./test/fixtures/sample_third_grade_CSAP.csv",
      :eighth_grade => "./test/fixtures/sample_eighth_grade_CSAP.csv",
      :math => "./test/fixtures/sample_statewide_math.csv",
      :reading => "./test/fixtures/sample_statewide_reading.csv",
      :writing => "./test/fixtures/sample_statewide_writing.csv"
      }
    }
  end

  def file_set_3
    {
      :enrollment => {
      :kindergarten => "./test/fixtures/sample_kindergarten.csv",
      :high_school_graduation => "./test/fixtures/sample_high_school.csv" },
      :statewide_testing => {
      :third_grade => "./test/fixtures/sample_third_grade_CSAP.csv",
      :eighth_grade => "./test/fixtures/sample_eighth_grade_CSAP.csv",
      :math => "./test/fixtures/sample_statewide_math.csv",
      :reading => "./test/fixtures/sample_statewide_reading.csv",
      :writing => "./test/fixtures/sample_statewide_writing.csv"
      }
    }
  end

  def econ_file_set
    {
    :economic_profile => {
    :median_household_income => "./test/fixtures/sample_median_household_income.csv",
    :children_in_poverty => "./test/fixtures/sample_school_aged_children_in_poverty.csv",
    :free_or_reduced_price_lunch => "./test/fixtures/sample_students_qualifying_for_lunch.csv",
    :title_i => "./test/fixtures/sample_title_i_students.csv"
    }
    }
  end

  def test_key_for_path_is_present
    pr = ParserRepository.new(econ_file_set)
    assert_equal [:economic_profile], pr.parsed.keys
  end

  def test_key_for_another_path_is_present
    pr = ParserRepository.new(file_set_3)
    assert_equal [:enrollment, :statewide], pr.parsed.keys
  end

  def test_parsed_data_returns_array_of_districts
    pr = ParserRepository.new(file_set_3)
    assert_equal ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"], pr.parsed[:statewide].keys
  end

  def test_keys_of_statewide_data_for_colorado_are_grades
    pr = ParserRepository.new(file_set_3)
    assert_equal [:third_grade, :eighth_grade, :all_students, :asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white], pr.parsed[:statewide]["COLORADO"].keys
  end

  def test_keys_of_statewide_data_for_key_of_colorado
    pr = ParserRepository.new(file_set)
    assert_equal [:name, :kindergarten_participation], pr.parsed[:enrollment].first["Colorado"].keys
  end

  def test_keys_of_statewide_data_for_first_element_of_colorado
    pr = ParserRepository.new(file_set)
    assert_equal [:name, :high_school_graduation], pr.parsed[:enrollment][1]["Colorado"].keys
  end

  def test_keys_of_stuff_do_stuff
    pr = ParserRepository.new(file_set_2)
    assert_equal [:math, :reading, :writing], pr.parsed[:statewide]["COLORADO"][:third_grade][2008].keys
  end

end
