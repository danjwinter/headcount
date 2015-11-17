require 'minitest/autorun'
require 'minitest/pride'
require 'minitest'
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

  def file_set_stellar
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten_stellar.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school_stellar.csv" }}
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

  def ready_iteration_two_analysis
    @dr = DistrictRepository.new
    @dr.load_data(file_set_3)
    @ha2 = HeadcountAnalyst.new(@dr)
  end

  def set_the_first_two_iterations
    @dr = DistrictRepository.new
    @dr.load_data(file_set)
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_class_exists
    ready_iteration_two_analysis
    assert @ha2
  end

  def test_kindergarten_participation_rate_variation_is_accurate_against_state
    set_the_first_two_iterations
    kprv = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 1.002, kprv
  end

  def test_truncate_truncates
    set_the_first_two_iterations
    assert_equal 1.234, @ha.truncate(1.2345)
  end

  def test_district1_grabs_district_object
    set_the_first_two_iterations
    assert_equal @dr.find_by_name("ACADEMY 20"), @ha.district1("ACADEMY 20")
  end

  def test_district1_returns_nil_if_object_doesnt_exist
    set_the_first_two_iterations
    assert_equal nil, @ha.district1("Unknown")
  end

  def test_district_2_grabs_district_object
    set_the_first_two_iterations
    vs_district2_name = {:against=>"COLORADO"}
    assert_equal @dr.find_by_name("Colorado"), @ha.district2(vs_district2_name)
  end

  def test_district_2_returns_nil_if_object_doesnt_exist
    set_the_first_two_iterations
    vs_district2_name = {:against=>"TURING"}
    assert_equal nil, @ha.district2(vs_district2_name)
  end

  def test_sum_participation_rate_adds_values_from_a_district
    set_the_first_two_iterations
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal 1.0110000000000001, @ha.sum_participation_rate(district, "kind")
    refute_equal 1, @ha.sum_participation_rate(district, "kind")
  end

  def test_participation_by_year_returns_array_of_values
    set_the_first_two_iterations
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal [0.391, 0.353, 0.267], @ha.participation_by_year(district, "kind")
  end

  def test_kindergarten_participation_rate_variation_is_accurate_against_district
    set_the_first_two_iterations
    kprv = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
    assert_equal 1.124, kprv
  end

  def test_kindergarten_participation_rate_variation_trend_returns_hash_with_average_of_each_year
    set_the_first_two_iterations
    variation_rate = @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')

    assert_equal({2005=>0.272, 2006=>0.344, 2007=>0.392}, variation_rate)
  end

  def test_hs_graduation_rate_is_accurate_vs_state
    set_the_first_two_iterations
    hsgr = @ha.hs_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 1.209, hsgr
  end

  def test_kindergarten_participation_against_high_school_graduation_rate
    set_the_first_two_iterations
    kpahsg = @ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')

    assert_equal 0.828, kpahsg
  end

  def test_correlation_window_between_kind_par_and_hsgr
    set_the_first_two_iterations
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_kindergarten_participation_corrs_wtih_hs_g_in_state_fails
    set_the_first_two_iterations
    refute @ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'COLORADO')
  end

  def test_kindergarten_participation_corrs_wtih_hs_g_in_state_passes
    set_the_first_two_iterations
    @dr.load_data(file_set_stellar)
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'COLORADO')
  end

  def test_kindergarten_participation_corrs_wtih_hs_g_in_state_passes
    set_the_first_two_iterations
    @dr.load_data(file_set_stellar)
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['ACADEMY 20', 'STELLAR SCHOOL', 'ADAMS COUNTY 14'])
  end

  def test_statewide_growth_year_over_year
    ready_iteration_two_analysis
    assert_equal ['COLORADO', 0.004],@ha2.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_statewide_growth_for_top_2_districts
    ready_iteration_two_analysis
    assert_equal [['COLORADO', 0.004], ["ACADEMY 20", -0.005]], @ha2.top_statewide_test_year_over_year_growth(grade: 3, top: 2, subject: :math)
  end

  def test_statewide_growth_across_all_subjects_when_only_given_grade
    ready_iteration_two_analysis
    assert_equal ["COLORADO", 0.004],@ha2.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_statewide_growth_across_all_subjects_when_only_given_grade_with_weighting
    ready_iteration_two_analysis
    assert_equal(["COLORADO", 0.002],@ha2.top_statewide_test_year_over_year_growth(grade: 3, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0}))
  end

  def test_if_no_grade_provided_in_year_over_year_growth_throw_insufficient_data_error
    ready_iteration_two_analysis
    exception = assert_raises(InsufficientInformationError) do
      @ha2.top_statewide_test_year_over_year_growth(subject: :math)
    end
    assert_equal('A grade must be provided to answer this question.', exception.message)
  end
  #
  # def test_if_bad_grade_provided_in_year_over_year_growth_throw_unknown_data_error
  #   ready_iteration_two_analysis
  #   exception = assert_raises(UnknownDataError) do
  #     @ha2.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)
  #   end
  #
  #   assert_equal("9 is not a known grade.", exception.message)
  # end





end
