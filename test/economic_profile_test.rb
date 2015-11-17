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

  def test_ec_prof_takes_data_on_instantiation
    assert EconomicProfile.new(data)
  end



end