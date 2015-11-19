require 'minitest/autorun'
require 'minitest/pride'
require './lib/title_i_parser'

class TitleIParserTest < Minitest::Test

  def setup
    @ti = TitleIParser.new
  end

  def file_set_title_i_students
    ["./test/fixtures/sample_title_i_students.csv", :title_i]
  end

  def load_title_i_file
    @ti.load_info(file_set_title_i_students)
  end

  def test_class_exists
    assert @ti
  end

  def test_class_starts_with_empty_hash
    assert_equal 0, @ti.data_set.count
  end

  def test_load_info_doesnt_return_nil
    load_title_i_file
    refute_equal nil, @ti.data_set_up
    refute_equal nil, @ti.district_data
  end

  def test_data_set_up_contains_data
    load_title_i_file
    assert_equal ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"], @ti.data_set_up.keys
  end

  def test_district_data_is_a_hash_of_arrays
    load_title_i_file
    assert_equal Array, @ti.district_data["Colorado"].class
  end

  def test_years_from_csv_are_in_data_set
    load_title_i_file
    assert_equal [2009, 2011, 2012, 2013, 2014], @ti.data_set["COLORADO"][:title_i].keys
  end

  def test_data_from_csv_is_in_data_set
    load_title_i_file
  end

  def test_student_in_title_i_appears_in_data_set
    load_title_i_file
    assert_equal 0.014, @ti.data_set["ACADEMY 20"][:title_i][2009]
  end

  def test_another_student_in_title_i_appears_in_data_set
    load_title_i_file
    assert_equal 0.35278, @ti.data_set["ADAMS-ARAPAHOE 28J"][:title_i][2014]
  end

end
