require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository'

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

  def test_why_arent_grades_showing_up
    @dr.load_data(file_set_3)

  end

  def test_statewide_reposhit
    skip
    @stwr = StatewideTestRepository.new
    @stwr.load_data(file_set_3)
  end

  end
