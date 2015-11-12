require 'minitest/autorun'
require 'minitest/pride'
require './lib/parser_repository'
require 'pry'

class ParserRepositoryTest < Minitest::Test

  def file_set
    {:enrollment => {
       :kindergarten => "./test/fixtures/sample_kindergarten.csv",
       :high_school_graduation => "./test/fixtures/sample_high_school.csv" }
    }
  end

  def setup
    @pr = ParserRepository.new(file_set)
  end

  def test_parser_repo_can_isolate_enrollment_requests
    assert_equal({  :kindergarten => "./test/fixtures/sample_kindergarten.csv",
                    :high_school_graduation => "./test/fixtures/sample_high_school.csv"}, @pr.enrollment)
  end

  def test_high_school_path_isolates_high_school
    assert_equal "./test/fixtures/sample_high_school.csv", @pr.high_school_path(@pr.enrollment)
  end

  def test_kindergarten_path_isolates_kindergarten
    assert_equal "./test/fixtures/sample_kindergarten.csv", @pr.kindergarten_path(@pr.enrollment)
  end

  def test_direct_path_directs_to_kindergarten_path
    kindergarten_data = @pr.parsed.first
    first_kindergarten_school = kindergarten_data.first
    first_kindergarten_school_name = first_kindergarten_school.first
    assert_equal "Colorado", first_kindergarten_school_name
  end

  



end