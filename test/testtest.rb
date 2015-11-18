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

  def file_set_2
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
    }
  end

  #
  # def test_all_data_coming_in
  #   dr = DistrictRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv",
  #       :high_school_graduation => "./data/High school graduation rates.csv",
  #     },
  #     :statewide_testing => {
  #       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
  #       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
  #       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
  #       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
  #       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  #     }
  #     })
  #     binding.pry
  # end



  def test_all_data_coming_in
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },

    def file_set_3
      {:enrollment => {
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


  def test_wtf

  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv",
    },
    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    },
    :economic_profile => {
    :median_household_income => "./test/fixtures/sample_median_household_income.csv",
    :children_in_poverty => "./test/fixtures/sample_school_aged_children_in_poverty.csv",
    :free_or_reduced_price_lunch => "./test/fixtures/sample_students_qualifying_for_lunch.csv",
    :title_i => "./test/fixtures/sample_title_i_students.csv"
    }
    })
    binding.pry
  end




# HA ANALYSIS BETWEEN YEARS FOR THIRD GRADE MATH
#   -.006
#   .015
# C = .0045
#
# -.033
# .025
# A20 = -.004
#
# -.02
# -.071
# A14 = -.0365
#
# -.017
# -.003
# AA28J = -.01
  end

  #deal with bad data
  #fix unknown data error in headcount analyst to test for message with string interpolation
  #spec harness bullshit
  #
