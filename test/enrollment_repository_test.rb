require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
  end

  def test_class_exists
    assert @er = EnrollmentRepository.new
  end

  def file_set
    {:enrollment => {
      :kindergarten => "./test/fixtures/sample_kindergarten.csv"
      }
    }
  end

  def test_enrollments_starts_as_empty_array
    assert_equal 0, @er.enrollments.length
    assert_equal({}, @er.enrollments)
  end

  def test_enrollments_loads_kindergarten_sample_data
    @er.load_enrollment_data(file_set)
    enrollments_keys = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]

    assert_equal 4, @er.enrollments.count
    assert_equal [Enrollment, Enrollment, Enrollment, Enrollment], @er.enrollments.values.map {|ob| ob.class}
    assert_equal Enrollment, @er.enrollments.fetch("Colorado").class
    assert_equal Enrollment, @er.enrollments.fetch("ACADEMY 20").class
    assert_equal enrollments_keys, @er.enrollments.keys
  end

  def test_enrollments_are_found_by_name
    @er.load_enrollment_data(file_set)
    enrollment_object1 = @er.find_by_name("Colorado")
    enrollment_object2 = @er.find_by_name("ACADEMY 20")

    assert_equal "COLORADO", enrollment_object1.name
    assert_equal Enrollment, enrollment_object1.class
    assert_equal "ACADEMY 20", enrollment_object2.name
    assert_equal Enrollment, enrollment_object2.class
  end

  def test_enrollments_are_not_found_if_name_doesnt_exist
    @er.load_enrollment_data(file_set)
    enrollment_object = @er.find_by_name("Montana")

    assert_equal nil, enrollment_object
  end

  # def test_find_all_matching_returns_empty_array_with_no_match
  #   @er.load_enrollment_data(file_set)
  #   enrollment_objects = @er.find_all_matching("zzz")
  #
  #   assert_equal [], enrollment_objects
  # end
  #
  # def test_find_all_matching_returns_data_with_one_match
  #   @er.load_enrollment_data(file_set)
  #   enrollment_objects = @er.find_all_matching("col")
  #
  #   assert_equal 1, enrollment_objects.count
  #   assert_equal [Enrollment], [enrollment_objects[0].class]
  # end
  #
  # def test_find_all_matching_returns_data_with_multiple_matches
  #   @er.load_enrollment_data(file_set)
  #   enrollment_objects = @er.find_all_matching("ada")
  #   first = enrollment_objects[0]
  #   second = enrollment_objects[1]
  #
  #   assert_equal 2, enrollment_objects.count
  #   assert_equal [Enrollment, Enrollment], [enrollment_objects[0].class, enrollment_objects[1].class]
  #   assert_equal "ADAMS COUNTY 14", first.name
  #   assert_equal "ADAMS-ARAPAHOE 28J", second.name
  # end

  end
