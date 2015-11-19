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

  def test_rate_variate_data_guard_returns_NA
    ready_iteration_two_analysis
    assert_equal "N/A", @ha2.rate_variation_data_guard("N/A", 0.123)
  end

  def test_rate_variation_data_guard_returns_number_if_not_NA
    ready_iteration_two_analysis
    assert_equal 0.891, @ha2.rate_variation_data_guard(0.2996666666666667, 0.336)
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

  def test_non_co_district_names_encompasses_individual_districts
    set_the_first_two_iterations
    assert_equal ["ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"], @ha.non_co_district_names
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
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'COLORADO')
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

  def test_single_district_kind_par_with_high_grad_works_if_colorado
    ready_iteration_two_analysis
    assert @ha2.single_district_kind_par_with_high_grad(for: "ACADEMY 20")
  end

  def test_single_district_kind_par_with_high_grad_works_if_statewide
    ready_iteration_two_analysis
    refute @ha2.single_district_kind_par_with_high_grad(for: "STATEWIDE")
  end

  def test_single_district_kind_par_with_grad_returns_false_if_false
    ready_iteration_two_analysis
    assert @ha2.single_district_kind_par_with_high_grad(for: "ADAMS COUNTY 14")
  end

  def test_returns_false_if_districts_are_under_point_7
    ready_iteration_two_analysis
    assert_equal false, @ha2.multiple_district_kind_par_with_high_grad({:across=>["ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]})
  end
  # 
  # def test_district_1_name_returns_name
  #   ready_iteration_two_analysis
  #   assert_equal "Brenna", @ha2.district1("Colorado")
  # end

  def test_statewide_growth_year_over_year
    ready_iteration_two_analysis
    method_call = @ha2.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    # assert_equal ['COLORADO', 0.004],@ha2.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal ['COLORADO', 0.004500000000000004],@ha2.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_statewide_growth_for_top_2_districts
    ready_iteration_two_analysis
    assert_equal [["COLORADO", 0.004500000000000004], ["ACADEMY 20", -0.0040000000000000036]], @ha2.top_statewide_test_year_over_year_growth(grade: 3, top: 2, subject: :math)
  end

  def test_statewide_growth_across_all_subjects_when_only_given_grade
    ready_iteration_two_analysis
    assert_equal ["COLORADO", 0.001],@ha2.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_statewide_growth_across_all_subjects_when_only_given_grade_with_weighting
    ready_iteration_two_analysis
    assert_equal(["COLORADO", 0.001],@ha2.top_statewide_test_year_over_year_growth(grade: 3, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0}))
  end

  def test_if_no_grade_provided_in_year_over_year_growth_throw_insufficient_data_error
    ready_iteration_two_analysis
    exception = assert_raises(InsufficientInformationError) do
      @ha2.top_statewide_test_year_over_year_growth(subject: :math)
    end
    assert_equal('A grade must be provided to answer this question.', exception.message)
  end

end
