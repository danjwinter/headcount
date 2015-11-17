require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/economic_profile'


class EconomicProfileTest < Minitest::Test

  def data
  {:median_household_income => {2015 => 50000, 2014 => 60000},
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
    assert EconomicProfile.new(data)
  end

  def test_median_household_income_can_be_accessed
    assert_equal({2015 => 50000, 2014 => 60000}, @ep.median_household_income)
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



end