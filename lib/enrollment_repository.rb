require_relative 'kindergarten_enrollment_parser'
require_relative 'enrollment'
require_relative 'parser_repository'
require 'pry'

class EnrollmentRepository
  attr_accessor :enrollments

  def initialize
    @enrollments = {}
  end

  def load_attributes(attribute)
    enrollments[enrollment] = Enrollment.new(attribute)
  end

  def load_enrollment_data(file_set)
    parsed_enrollment_data(file_set).each do |category_data|
      load_enrollments(category_data)
    end
  end

  def load_enrollments(category_data)
    category_data.each_pair do |enrollment, attribute|
      if enrollments[enrollment].nil?
        enrollments[enrollment] = Enrollment.new(enrollment)
        enrollments[enrollment].load_new_data(attribute)
      else
        enrollments[enrollment].load_new_data(attribute)
      end
    end
  end

  def parsed_enrollment_data(file_set)
    ParserRepository.new(file_set).parsed
  end

  def find_by_name(name)
    @enrollments.key?(name) ? @enrollments.fetch(name) : nil
  end

  # def find_all_matching(frag)
  #   @enrollments.values.find_all do |enrollment|
  #     enrollment.name.include?(frag.upcase)
  #   end
  # end
end
