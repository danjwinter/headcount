require 'minitest/autorun'
require 'minitest/emoji'
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

  def wtf
    load_children_in_poverty
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