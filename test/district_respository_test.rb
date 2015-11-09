require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
  end

  def test_class_exists
    assert dr = DistrictRepository.new
  end

  def test_load_data_helper_finds_a_value
    path = "./data/Kindergartners in full-day program.csv"
    file_set = {:kindergarten => "./data/Kindergartners in full-day program.csv"}
    assert_equal [path], @dr.path(file_set)
  end

end
