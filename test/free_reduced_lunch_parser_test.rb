require 'minitest/autorun'
require 'minitest/emoji'
require './lib/free_reduced_lunch_parser'

class FreeReducedLunchParserTest < Minitest::Test

  # def file_path
  #   { :economic_profile => {
  #       :median_household_income => "./test/fixtures/sample_median_household_income.csv"
  #       :children_in_poverty => "./test/fixtures/sample_school_aged_children_in_poverty.csv",
  #       :free_or_reduced_price_lunch => "./test/fixtures/sample_students_qualifying_for_lunch.csv",
  #       :title_i => "./test/fixtures/sample_title_i_students.csv"
  #     }
  # end

  def setup
    @frlp = FreeReducedLunchParser.new
  end

  def file_set_free_reduced_lunch
  ["./test/fixtures/sample_students_qualifying_for_lunch.csv", :free_or_reduced_price_lunch]
  end

  def load_lunch_path
    @frlp.load_info(file_set_free_reduced_lunch)
  end

  def test_total_can_be_extracted
    load_lunch_path
    assert_equal 3006, @frlp.data_set["ACADEMY 20"][:free_or_reduced_price_lunch][2012][:total]
  end

  def test_percentage_can_be_extracted
    load_lunch_path
    assert_equal 0.56, @frlp.data_set["ADAMS COUNTY 14"][:free_or_reduced_price_lunch][2000][:percentage]
  end

  def test_data_set_begins_as_an_empty_hash
    assert_equal({}, @frlp.data_set)
  end

end
