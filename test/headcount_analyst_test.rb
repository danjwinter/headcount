require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def file_set
    {:enrollment => {
      :kindergarten => "./test/fixtures/sample_kindergarten.csv"
      }
    }
  end

  def setup
    @dr = DistrictRepository.new
    @dr.load_data(file_set)
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_class_exists
    assert @ha
  end

  def test_kindergarten_participation_rate_variation_is_accurate
    kprv = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 1.002, kprv
  end




end
