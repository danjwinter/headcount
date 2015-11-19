require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def setup
    @st = StatewideTest.new("ACADEMY 20")
    @st1 = StatewideTest.new("Colorado")
  end

  def hash_access(value)
    new_value = {}
    value.each do |key, value|
      new_value[key] = value.each do |next_key, next_value|
        value[next_key] = truncate(next_value)
      end
    end
    new_value
  end

  def truncate(value)
    ((value * 1000).floor/1000.0)
  end

  def statewide_data_3
    {
      :third_grade => { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
       2009 => {:math => 0.8245, :reading => 0.862, :writing => 0.706},
       2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
       2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
       2012 => {:math => 0.830, :reading => 0.8790, :writing => 0.655},
       2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
       2014 => {:math => 0.8341, :reading => 0.831, :writing => 0.639}
      }
    }
  end

  def truncated_statewide_data_3
    {
      :third_grade => { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
       2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
       2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
       2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
       2012 => {:math => 0.830, :reading => 0.879, :writing => 0.655},
       2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
       2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
      }
    }
  end

  def statewide_data_8
    {
      :eighth_grade => { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
      2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
      2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
      2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
      2012 => {:math => 0.830, :reading => 0.587, :writing => 0.655},
      2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
      2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
      }
    }
  end

  def asian_data
    {
      :asian => { 2011 => {math: 0.816, reading: 0.897, writing: 0.8826},
      2012 => {math: 0.818, reading: 0.893, writing: 0.808},
      2013 => {math: 0.8085, reading: 0.901, writing: 0.810},
      2014 => {math: 0.800, reading: 0.8855, writing: 0.789},
      }
    }
  end

  def pacific_islander_data
   {
      :pacific_islander => { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
      2012 => {math: 0.818, reading: 0.893, writing: 0.808},
      2013 => {math: 0.805, reading: 0.901, writing: 0.810},
      2014 => {math: 0.800, reading: 0.855, writing: 0.789},
      }
    }
  end

  def test_class_exists
    assert @st
  end

  def test_it_has_a_name
    assert_equal "ACADEMY 20", @st.name
  end

  def test_name_will_always_be_uppercase
    assert_equal "COLORADO", @st1.name
  end

  def test_it_can_retrieve_third_grade_data
    @st.load_new_data(statewide_data_3)
    assert_equal truncated_statewide_data_3.fetch(:third_grade), @st.proficient_by_grade(3)
  end

  def test_it_can_retrieve_eighth_grade_data
    @st.load_new_data(statewide_data_8)
    assert_equal statewide_data_8.fetch(:eighth_grade), @st.proficient_by_grade(8)
  end

  def test_it_raises_an_error_with_bad_grade
    @st.load_new_data(statewide_data_8)
    assert_raises UnknownDataError do
      @st.proficient_by_grade(5)
    end
  end

  def test_it_can_find_data_based_on_race
    @st.load_new_data(asian_data)
    assert_equal hash_access(asian_data.fetch(:asian)), @st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_it_raises_an_error_with_unavailable_data
    @st.load_new_data(asian_data)
    assert_raises UnknownRaceError do
      @st.proficient_by_race_or_ethnicity(:canuck)
    end
  end

  def test_it_finds_data_based_on_a_different_race
    @st.load_new_data(pacific_islander_data)
    assert_equal hash_access(pacific_islander_data.fetch(:pacific_islander)), @st.proficient_by_race_or_ethnicity(:pacific_islander)
  end

  def test_it_finds_data_based_on_specific_year_subject_and_race
    @st.load_new_data(asian_data)
    asian_math_2012 = @st.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
    assert_equal 0.818, asian_math_2012
  end

  def test_it_raises_an_error_with_unavailable_subject_data_for_proficient_subject_by_race_in_year
    @st.load_new_data(asian_data)
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_race_in_year(:science, :asian, 2012)
    end
  end

  def test_it_raises_an_error_with_unavailable_race_data_for_proficient_subject_by_race_in_year
    @st.load_new_data(asian_data)
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_race_in_year(:math, :canuck, 2012)
    end
  end

  def test_it_raises_an_error_with_unavailable_subject_data_for_proficient_subject_by_race_in_year
    @st.load_new_data(asian_data)
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_race_in_year(:math, :asian, 1776)
    end
  end

  def test_it_finds_data_based_on_specific_year_subject_and_grade
    @st.load_new_data(statewide_data_3)
    third_grade_math_2012 = @st.proficient_for_subject_by_grade_in_year(:math, 3, 2012)
    assert_equal 0.830, third_grade_math_2012
  end

  def test_it_finds_data_based_on_specific_year_subject_and_eighth_grade
    @st.load_new_data(statewide_data_8)
    third_grade_math_2012 = @st.proficient_for_subject_by_grade_in_year(:math, 8, 2013)
    assert_equal 0.855, third_grade_math_2012
  end

  def test_it_raises_an_error_with_unavailable_subject_data_for_proficient_subject_by_grade_in_year
    @st.load_new_data(statewide_data_3)
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_grade_in_year(:science, 3, 2013)
    end
  end

  def test_it_raises_an_error_with_unavailable_grade_data_for_proficient_subject_by_grade_in_year
    @st.load_new_data(statewide_data_3)
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_grade_in_year(:math, 5, 2013)
    end
  end

  def test_it_raises_an_error_with_unavailable_year_data_for_proficient_subject_by_grade_in_year
    @st.load_new_data(statewide_data_3)
    assert_raises UnknownDataError do
      @st.proficient_for_subject_by_grade_in_year(:math, 5, 1960)
    end
  end

end
