require 'minitest/autorun'
require 'minitest/pride'
require './lib/grade_statewide_parser'

class GradeStatewideParserTest < Minitest::Test

  def file_set_eighth_grade_statewide
      "./test/fixtures/sample_eighth_grade_CSAP.csv"
  end

  # def raw_math_prep_data
  #   [{2011 => {:location=>"ADAMS COUNTY 14", :timeframe=>"2007", :dataformat=>"Percent", :data=>"0.30643"},
  #  {:location=>"ADAMS COUNTY 14", :timeframe=>"2006", :dataformat=>"Percent", :data=>"0.29331"}
  # }]
  # end

  # def academy_20_parsed_district_data
  #   {:name=>"ACADEMY 20", :math=>{2007=>0.39159, 2006=>0.35364, 2005=>0.26709}}
  # end

  def setup
    @gsp = GradeStatewideParser.new([file_set_eighth_grade_statewide, :eighth_grade])
  end

  def test_parser_creates_array_of_one_hash_upon_initialization
    assert_equal Hash, @gsp.csv[0].class
  end

  def test_district_data_creates_keys_based_on_locations
    locations = ["Colorado", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal locations, @gsp.district_data.keys
  end

  def test_district_data_prints_value
    stats1 = ({2008=> {:math => 0.469, :reading => 0.703, :writing => 0.529},
    2009=>{:math => 0.499, :reading => 0.726, :writing => 0.528},
    2010=>{:math => 0.51, :reading => 0.679, :writing => 0.549}})
    assert_equal({:name=>"COLORADO", :eighth_grade => stats1}, @gsp.district_data.first[1])

    binding.pry
    # assert_equal academy_20_parsed_district_data, @gsp.district_data.fetch("ACADEMY 20")
  end

  # def test_kindergarten_participation_prmsp_returns_kind_par_data
  #   assert_equal({2007=>0.30643, 2006=>0.29331, 2005=>0.3}, @ep.kindergarten_participation_prep(raw_kind_prep_data))
  # end

end



