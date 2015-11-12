require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def setup
    @en = Enrollment.new(enrollment_name)
    # @en_bad = Enrollment.new(enrollment_bad_data)
  end

  def enrollment_name
    # {:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
    "ACADEMY 20"
  end

  def kind_part_data
    {:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
  end

  def enrollment_bad_data
    {:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => "APPLESAUCE"}}
  end

  def test_class_exists
    assert @en
  end

  def test_name_outputs_academy_20
    assert_equal "ACADEMY 20", @en.name
  end

  def test_kindgergarten_participation_by_year_returns_a_hash_of_years
    @en.load_new_data(kind_part_data)
    output_data = { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267 }
    assert_equal output_data, @en.kindergarten_participation_by_year
  end

  def test_kindgergarten_participation_in_year_by_year_returns_float
    @en.load_new_data(kind_part_data)
    assert_equal 0.391, @en.kindergarten_participation_in_year(2010)
  end

  def test_kindgergarten_participation_in_year_with_sad_year_returns_nil
    @en.load_new_data(kind_part_data)
    assert_equal nil, @en.kindergarten_participation_in_year(1776)
  end
  #
  # def test_bad_data_is_cleaned_up
  #   output_data = {2010 => 0.3915, 2011 => 0.35356, 2012 => "N/A"}
  #
  #   assert_equal output_data, @en_bad.clean_kindergarten_participation_numbers
  # end

  ###################################################
  # ITERATION 1

  def hs_load_data
    {:high_school_graduation=>{2010=>0.455, 2011=>0.485, 2012=>0.47984}}
  end

  # def test_high_school_graduation_is_loaded_into_district_repository
  #   @en.load_new_data(hs_load_data)
  #   adams_arapaho_hs_grad_data = {2010=>0.455, 2011=>0.485, 2012=>0.47984}
  #   assert_equal adams_arapaho_hs_grad_data,
  # end

end
