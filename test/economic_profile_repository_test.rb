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

end
