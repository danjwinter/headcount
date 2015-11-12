require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def file_set
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
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

  def test_kindergarten_participation_rate_variation_is_accurate_against_state
    kprv = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 1.002, kprv
  end

  def test_truncate_truncates
    assert_equal 1.234, @ha.truncate(1.2345)
  end

  def test_district1_grabs_district_object
    assert_equal @dr.find_by_name("ACADEMY 20"), @ha.district1("ACADEMY 20")
  end

  def test_district1_returns_nil_if_object_doesnt_exist
    assert_equal nil, @ha.district1("Unknown")
  end

  def test_district_2_grabs_district_object
    vs_district2_name = {:against=>"COLORADO"}
    assert_equal @dr.find_by_name("Colorado"), @ha.district2(vs_district2_name)
  end

  def test_district_2_returns_nil_if_object_doesnt_exist
    vs_district2_name = {:against=>"TURING"}
    assert_equal nil, @ha.district2(vs_district2_name)
  end

  def test_sum_participation_rate_adds_values_from_a_district
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal 1.0110000000000001, @ha.sum_participation_rate(district, "kind")
    refute_equal 1, @ha.sum_participation_rate(district, "kind")
  end

  def test_participation_by_year_returns_array_of_values
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal [0.391, 0.353, 0.267], @ha.participation_by_year(district, "kind")
  end

  def test_kindergarten_participation_rate_variation_is_accurate_against_district
    kprv = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
    assert_equal 1.124, kprv
  end

  def test_kindergarten_participation_rate_variation_trend_returns_hash_with_average_of_each_year
    variation_rate = @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    assert_equal({2005=>0.272, 2006=>0.344, 2007=>0.392}, variation_rate)
  end

  def test_hs_graduation_rate_is_accurate_vs_state
    hsgr = @ha.hs_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 1.209, hsgr
  end

  def test_kindergarten_participation_against_high_school_graduation_rate
    kpahsg = @ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')

    assert_equal 0.828, kpahsg
  end

end
