require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository'
require './lib/headcount_analyst'

class TestTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
  end

  def file_set
    {:enrollment => {
      :kindergarten => "./test/fixtures/sample_kindergarten.csv"
      }
    }
  end

  # def test_enrollments
  #   @dr.load_data(file_set)
  # end

  def test_statewide_kindergarten_high_school_prediction
   dr = DistrictRepository.new
   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                 :high_school_graduation => "./data/High school graduation rates.csv"}})
   ha = HeadcountAnalyst.new(dr)
   binding.pry

   refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
 end

  def file_set_2
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
    }
  end
end

  #deal with bad data
  #fix unknown data error in headcount analyst to test for message with string interpolation
  #spec harness bullshit
  #
