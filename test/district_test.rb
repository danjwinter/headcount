require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district'
require './lib/district_repository'

class DistrictTest < Minitest::Test

  def setup
    @d1 = District.new({:name => "ACADEMY 20", enrollment: "enrollment obj for academy 20", statewide: "statewide obj for academy 20"})
    @d2 = District.new({:name => "COLORADO", enrollment: "enrollment obj for Colorado", statewide: "statewide obj for Colorado"})
  end

  def file_set
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
    }
  end

  def test_class_exists
    assert @d1
  end

  def test_name_returns_upcased_string_of_district
    assert_equal "ACADEMY 20", @d1.name
    assert_equal "COLORADO", @d2.name
  end

  def test_name_is_not_still_lowercase
    refute_equal "Colorado", @d2.name
    refute_equal "Academy 20", @d1.name
  end

  def test_district_points_to_correct_enrollment
    @dr = DistrictRepository.new
    @dr.load_data(file_set)
    ac20obj = @dr.find_by_name("Academy 20")
    ad14obj = @dr.find_by_name("Adams County 14")

    assert_equal "ACADEMY 20", ac20obj.name
    assert_equal "ACADEMY 20", ac20obj.enrollment.name

    assert_equal "ADAMS COUNTY 14", ad14obj.name
    assert_equal "ADAMS COUNTY 14", ad14obj.enrollment.name
  end


end
