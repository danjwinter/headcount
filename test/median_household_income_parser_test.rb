require 'minitest/autorun'
require 'minitest/pride'
require './lib/median_household_income_parser'

class MedianHouseholdIncomeParserTest < Minitest::Test

  def setup
    @mhi = MedianHouseholdIncomeParser.new
  end

  def file_set_median_household_income
    ["./test/fixtures/sample_median_household_income.csv", :median_household_income]
  end

  def load_median_household_income
    @mhi.load_info(file_set_median_household_income)
  end

  def test_class_exists
    assert @mhi
  end

  def test_class_starts_with_empty_hash
    assert_equal 0, @mhi.data_set.count
  end

  def test_load_info_doesnt_return_nil
    load_median_household_income
    refute_equal nil, @mhi.data_set_up
    refute_equal nil, @mhi.district_data
  end

  def test_data_set_up_contains_data
    load_median_household_income
    assert_equal ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"], @mhi.data_set_up.keys
  end

  def test_district_data_is_a_hash_of_arrays
    load_median_household_income
    assert_equal Array, @mhi.district_data["Colorado"].class
  end

  def test_years_from_csv_are_in_data_set
    load_median_household_income
    assert_equal [[2005, 2009], [2006, 2010], [2008, 2012], [2007, 2011], [2009, 2013]], @mhi.data_set["COLORADO"][:median_household_income].keys
  end

end
