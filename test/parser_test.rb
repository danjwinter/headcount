require 'minitest/autorun'
require 'minitest/pride'
require './lib/parser'

class ParserTest < Minitest::Test

  def setup
    @p = Parser.new("./test/fixtures/sample_kindergarten.csv")
  end

  def test_headers_print_from_sample_data
    assert_equal ["Location", "TimeFrame", "DataFormat", "Data"], @p.csv.headers
  end

  def test_districts_returns_array_of_values
    assert_equal [{:name=>"Colorado"},
 {:name=>"ACADEMY 20"}], @p.districts
  end

end
