require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def setup
    @epr = EconomicProfileRepository.new
  end

  def test_class_exists
    assert @epr
  end

  def file_set
    {
    :economic_profile => {
    :median_household_income => "./test/fixtures/sample_median_household_income.csv",
    :children_in_poverty => "./test/fixtures/sample_school_aged_children_in_poverty.csv",
    :free_or_reduced_price_lunch => "./test/fixtures/sample_students_qualifying_for_lunch.csv",
    :title_i => "./test/fixtures/sample_title_i_students.csv"
    }
    }
  end

  def test_econ_repo_starts_as_empty_hash
    assert_equal 0, @epr.ep_records.length
    assert_equal({}, @epr.ep_records)
  end

  def test_economic_loads_econ_sample_data
    @epr.load_data(file_set)
    ep_records_keys = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    
    assert_equal 4, @epr.ep_records.count
    assert_equal [EconomicProfile, EconomicProfile, EconomicProfile, EconomicProfile], @epr.ep_records.values.map {|ob| ob.class}
    assert_equal EconomicProfile, @epr.ep_records.fetch("COLORADO").class
    assert_equal EconomicProfile, @epr.ep_records.fetch("ACADEMY 20").class
    assert_equal ep_records_keys, @epr.ep_records.keys
  end

  def test_economics_are_found_by_name
    @epr.load_data(file_set)
    economic_object1 = @epr.find_by_name("Colorado")
    economic_object2 = @epr.find_by_name("ACADEMY 20")

    assert_equal "COLORADO", economic_object1.name
    assert_equal EconomicProfile, economic_object1.class
    assert_equal "ACADEMY 20", economic_object2.name
    assert_equal EconomicProfile, economic_object2.class
  end

  def test_enrollments_are_not_found_if_name_doesnt_exist
    @epr.load_data(file_set)
    economic_object = @epr.find_by_name("Montana")

    assert_equal nil, economic_object
  end


end
