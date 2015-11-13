require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def setup
    @st = StatewideTest.new("ACADEMY 20")
    @st1 = StatewideTest.new("Colorado")
  end

  def statewide_data_3
    {:third_grade => { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
     2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
     2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
     2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
     2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
     2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
     2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
   }}
  end

  def statewide_data_8
    {:eighth_grade => { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
     2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
     2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
     2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
     2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
     2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
     2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
     }}
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
    assert_equal statewide_data_3.fetch(:third_grade),@st.proficient_by_grade(3)
  end

  def test_it_can_retrieve_eighth_grade_data
    @st.load_new_data(statewide_data_8)
    assert_equal statewide_data_8.fetch(:eighth_grade),@st.proficient_by_grade(8)
  end

  def test_it_raises_an_error_with_bad_grade
    @st.load_new_data(statewide_data_8)
    assert_raises UnknownDataError do
      @st.proficient_by_grade(5)
    end
  end


end
