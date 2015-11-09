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
    assert_equal path, @dr.path(file_set)
  end

  def test_districts_starts_as_empty_array
    assert_equal 0, @dr.districts.length
    assert_equal [], @dr.districts
  end

  def test_districts_loads_kindergarten_sample_data
    @dr.load_data(:kindergarten => "./test/fixtures/sample_kindergarten.csv")
    assert_equal 2, @dr.districts.count
    assert_equal "COLORADO", @dr.districts[0].name
    assert_equal "ACADEMY 20", @dr.districts[1].name
  end

  def test_districts_are_found_by_name
    @dr.load_data(:kindergarten => "./test/fixtures/sample_kindergarten.csv")
    district_object = @dr.find_by_name("Colorado")
    assert_equal "COLORADO", district_object.name
  end

end
