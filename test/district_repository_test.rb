require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
  end

  def file_set
    {:enrollment => {
      :kindergarten => "./test/fixtures/sample_kindergarten.csv"
      }
    }
  end

  def find_class_of_objects_in_districts
    @dr.districts.map {|dis| dis.class}
  end

  def test_class_exists
    assert dr = DistrictRepository.new
  end

  def test_load_data_helper_finds_a_value
    path = "./test/fixtures/sample_kindergarten.csv"

    assert_equal path, @dr.path(file_set)
  end

  def test_districts_starts_as_empty_array
    assert_equal 0, @dr.districts.length
    assert_equal({}, @dr.districts)
  end

  def test_districts_loads_kindergarten_sample_data
    @dr.load_data(file_set)
    districts_keys = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]

    assert_equal 4, @dr.districts.count
    assert_equal [District, District, District, District], @dr.districts.values.map {|ob| ob.class}
    assert_equal District, @dr.districts.fetch("Colorado").class
    assert_equal District, @dr.districts.fetch("ACADEMY 20").class
    assert_equal districts_keys, @dr.districts.keys
  end

  def test_districts_are_found_by_name
    @dr.load_data(file_set)
    district_object1 = @dr.find_by_name("Colorado")
    district_object2 = @dr.find_by_name("ACADEMY 20")

    assert_equal "COLORADO", district_object1.name
    assert_equal District, district_object1.class
    assert_equal "ACADEMY 20", district_object2.name
    assert_equal District, district_object2.class
  end

  def test_districts_are_not_found_if_name_doesnt_exist
    @dr.load_data(file_set)
    district_object = @dr.find_by_name("Montana")

    assert_equal nil, district_object
  end

  def test_find_all_matching_returns_empty_array_with_no_match
    @dr.load_data(file_set)
    district_objects = @dr.find_all_matching("zzz")

    assert_equal [], district_objects
  end

  def test_find_all_matching_returns_data_with_one_match
    @dr.load_data(file_set)
    district_objects = @dr.find_all_matching("col")

    assert_equal 1, district_objects.count
    assert_equal [District], [district_objects[0].class]
  end

  def test_find_all_matching_returns_data_with_multiple_matches
    @dr.load_data(file_set)
    district_objects = @dr.find_all_matching("ada")
    first = district_objects[0]
    second = district_objects[1]

    assert_equal 2, district_objects.count
    assert_equal [District, District], [district_objects[0].class, district_objects[1].class]
    assert_equal "ADAMS COUNTY 14", first.name
    assert_equal "ADAMS-ARAPAHOE 28J", second.name
  end

  def test_district_repo_creates_enroll_repo_automatically
    @dr.load_data(file_set)
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal 0.391, district.enrollment.kindergarten_participation_in_year(2007)
  end

end
