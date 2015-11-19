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

  def test_year_in_range_is_included
    load_median_household_income

  end

end
