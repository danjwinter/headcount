require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/economic_profile'


class EconomicProfileTest < Minitest::Test

  def original_data
  {:median_household_income => {2015 => 50000, 2014 => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
       }
     end

  def data
    {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
       }
     end

  def test_class_exists
    assert EconomicProfile
  end

  def setup
    @ep = EconomicProfile.new(data)
  end

  def test_ec_prof_takes_data_on_instantiation
    assert @ep
  end

  def test_median_household_income_can_be_accessed
    assert_equal({[2005, 2009] => 50000, [2008, 2014] => 60000}, @ep.median_household_income)
  end

  def test_children_in_poverty_can_be_accessed
    assert_equal({2012 => 0.1845}, @ep.children_in_poverty)
  end

  def test_free_or_reduced_price_lunch_can_be_accessed
    assert_equal({2014 => {:percentage => 0.023, :total => 100}}, @ep.free_or_reduced_price_lunch)
  end

  def test_title_i_can_be_accessed
    assert_equal({2015 => 0.543}, @ep.title_i)
  end

  def test_estimated_median_household_income_in_year_by_year
    assert_equal 50000, @ep.estimated_median_household_income_in_year(2005)
  end

  def test_estimated_median_household_income_in_year_by_year_for_year_in_multiple_income_ranges
    assert_equal 55000, @ep.estimated_median_household_income_in_year(2008)
  end

  def test_median_household_income_average_returns_average_of_
    assert_equal 55000, @ep.median_household_income_average
  end

  def test_it_extracts_children_in_poverty_in_year
    assert_equal 0.184, @ep.children_in_poverty_in_year(2012)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_by_year
    assert_equal 0.023, @ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_by_year_raises_error_with_unknown_year
    assert_raises UnknownDataError do
       @ep.free_or_reduced_price_lunch_percentage_in_year(14)
    end
  end

  def test_free_or_reduced_price_lunch_total_in_year_by_year
    assert_equal 100, @ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_free_or_reduced_price_lunch_total_in_year_by_year_raises_error_with_unknown_year
    assert_raises UnknownDataError do
       @ep.free_or_reduced_price_lunch_percentage_in_year(14)
    end
  end

  def test_title_i_in_year_by_year
    assert_equal 0.543, @ep.title_i_in_year(2015)
  end

  def test_title_i_in_year_by_year_rasises_error_for_unknown_year
    assert_raises UnknownDataError do
       @ep.title_i_in_year(14)
    end
  end


end
