require 'minitest/autorun'
require 'minitest/emoji'
require './lib/poverty_parser'

class PovertyParserTest < Minitest::Test

  def setup
    @pp = PovertyParser.new
  end

  def file_set_children_in_poverty
    ["./test/fixtures/sample_school_aged_children_in_poverty.csv", :children_in_poverty]
  end

  def load_children_in_poverty
    @pp.load_info(file_set_children_in_poverty)
  end

  def test_year_in_range_is_included
    load_children_in_poverty
  end

  def test_children_in_poverty_appear_in_data_set
    load_children_in_poverty
    assert_equal 0.184, @pp.data_set["ADAMS COUNTY 14"][:children_in_poverty][2001]
  end

  def test_children_in_poverty_appear_in_data_set_for_other_districts
    load_children_in_poverty
    assert_equal 0.05754, @pp.data_set["ACADEMY 20"][:children_in_poverty][2010]
  end

end