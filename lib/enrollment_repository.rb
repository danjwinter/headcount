require_relative 'kindergarten_enrollment_parser'
require_relative 'enrollment'
require_relative 'parser_repository'
require 'pry'

class EnrollmentRepository
  attr_accessor :e_records

  def initialize
    @e_records = {}
  end

  def load_attributes(attribute)
    e_records[enrollment] = Enrollment.new(attribute)
  end

  def load_enrollment_data(file_set)
    parsed_enrollment_data(file_set).each do |category_data|
      load_enrollments(category_data)
    end
  end

  def load_enrollments(category_data)
    category_data.each_pair do |enrollment, attribute|
      if e_records[enrollment].nil?
        e_records[enrollment] = Enrollment.new(enrollment)
      end
      e_records[enrollment].load_new_data(attribute)
    end
  end

  def parsed_enrollment_data(file_set)
    ParserRepository.new(file_set).parsed
  end

  def find_by_name(name)
    @e_records.key?(name) ? @e_records.fetch(name) : nil
  end
end
