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

  def file_set_2
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
    }
  end

  def test_enrollments_starts_as_empty_hash
    skip
    assert_equal 0, @er.e_records.length
    assert_equal({}, @er.e_records)
  end

  def test_enrollments_loads_kindergarten_sample_data
    skip
    @er.load_data(file_set)
    e_records_keys = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]

    assert_equal 4, @er.e_records.count
    assert_equal [Enrollment, Enrollment, Enrollment, Enrollment], @er.e_records.values.map {|ob| ob.class}
    assert_equal Enrollment, @er.e_records.fetch("COLORADO").class
    assert_equal Enrollment, @er.e_records.fetch("ACADEMY 20").class
    assert_equal e_records_keys, @er.e_records.keys
  end

  def test_enrollments_are_found_by_name
    skip
    @er.load_data(file_set)
    enrollment_object1 = @er.find_by_name("Colorado")
    enrollment_object2 = @er.find_by_name("ACADEMY 20")

    assert_equal "COLORADO", enrollment_object1.name
    assert_equal Enrollment, enrollment_object1.class
    assert_equal "ACADEMY 20", enrollment_object2.name
    assert_equal Enrollment, enrollment_object2.class
  end

  def test_enrollments_are_not_found_if_name_doesnt_exist
    @er.load_data(file_set)
    enrollment_object = @er.find_by_name("Montana")

    assert_equal nil, enrollment_object
  end


end
