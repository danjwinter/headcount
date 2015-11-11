require 'minitest/autorun'
require 'minitest/pride'
require './lib/parser_repository'

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
    skip
    assert_equal({  :kindergarten => "./test/fixtures/sample_kindergarten.csv",
                    :high_school_graduation => "./test/fixtures/sample_high_school.csv"}, @pr.enrollment)
  end


end
