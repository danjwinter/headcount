require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def setup
    @str = StatewideTestRepository.new
  end

  def file_set
    {
      :statewide_testing => {
      :third_grade => "./test/fixtures/sample_third_grade_CSAP.csv",
      :eighth_grade => "./test/fixtures/sample_eighth_grade_CSAP.csv",
      :math => "./test/fixtures/sample_statewide_math.csv",
      :reading => "./test/fixtures/sample_statewide_reading.csv",
      :writing => "./test/fixtures/sample_statewide_writing.csv"
      }
    }
  end

  def test_class_exists
    assert @str
  end

  def test_statewide_records_starts_as_empty_hash
    assert_equal 0, @str.st_records.length
    assert_equal({}, @str.st_records)
  end

  def test_statewide_repo_can_load_data
    @str.load_data(file_set)
    st_records_keys = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]

    assert_equal 4, @str.st_records.count
    assert_equal [StatewideTest, StatewideTest, StatewideTest, StatewideTest], @str.st_records.values.map {|ob| ob.class}
    assert_equal StatewideTest, @str.st_records.fetch("COLORADO").class
    assert_equal StatewideTest, @str.st_records.fetch("ACADEMY 20").class
    assert_equal st_records_keys, @str.st_records.keys
  end

  def test_statewide_repo_can_find_by_name
    @str.load_data(file_set)
    statewide_object1 = @str.find_by_name("Colorado")
    statewide_object2 = @str.find_by_name("ACADEMY 20")

    assert_equal "COLORADO", statewide_object1.name
    assert_equal StatewideTest, statewide_object1.class
    assert_equal "ACADEMY 20", statewide_object2.name
    assert_equal StatewideTest, statewide_object2.class
  end

  def test_statewide_tests_are_not_found_if_name_doesnt_exist
    @str.load_data(file_set)
    enrollment_object = @str.find_by_name("Montana")
    assert_equal nil, enrollment_object
  end

end
