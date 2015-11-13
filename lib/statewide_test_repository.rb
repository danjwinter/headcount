require_relative 'kindergarten_enrollment_parser'
require_relative 'enrollment'
require_relative 'parser_repository'
require_relative 'district_repository'
require 'pry'

class StatewideTestRepository
  attr_accessor :st_records, :district_repository

  def initialize
    @st_records = {}
  end


end
