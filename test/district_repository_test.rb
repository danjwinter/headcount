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

  def file_set_2
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
    }
  end

  def find_class_of_objects_in_d_records
    @dr.d_records.map {|dis| dis.class}
  end

  def test_class_exists
    assert dr = DistrictRepository.new
  end

  def test_d_records_starts_as_empty_hash
    assert_equal 0, @dr.d_records.length
    assert_equal({}, @dr.d_records)
  end

  def test_d_records_loads_kindergarten_sample_data
    @dr.load_data(file_set)
    d_records_keys = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]

    assert_equal 4, @dr.d_records.count
    assert_equal [District, District, District, District], @dr.d_records.values.map {|ob| ob.class}
    assert_equal District, @dr.d_records.fetch("COLORADO").class
    assert_equal District, @dr.d_records.fetch("ACADEMY 20").class
    assert_equal d_records_keys, @dr.d_records.keys
  end

  def test_districts_are_found_by_name_with_capitalized_name
    @dr.load_data(file_set)
    district_object2 = @dr.find_by_name("Academy 20")

    assert_equal "ACADEMY 20", district_object2.name
    assert_equal District, district_object2.class
  end

  def test_district_are_found_by_name_with_all_lowercase_letters
    @dr.load_data(file_set)
    district_object1 = @dr.find_by_name("academy 20")

    assert_equal "ACADEMY 20", district_object1.name
    assert_equal District, district_object1.class
  end

  def test_districts_are_found_by_name_with_all_caps
    @dr.load_data(file_set)
    district_object1 = @dr.find_by_name("COLORADO")

    assert_equal "COLORADO", district_object1.name
    assert_equal District, district_object1.class
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

  def test_enrollment_repository_defaults_to_falsey
    refute @dr.enrollment_repository
  end

  def test_enrollment_repository_is_created_when_files_are_loaded
    @dr.load_data(file_set)
    assert @dr.enrollment_repository

    assert_equal Enrollment, @dr.enrollment_repository.e_records.values.first.class
    assert @dr.enrollment_repository.e_records.count > 2
  end

end
