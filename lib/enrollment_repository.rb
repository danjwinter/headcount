require_relative 'enrollment_parser'
require_relative 'enrollment'
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
    parsed_enrollment_data(file_set).each_pair do |enrollment, attribute|
      enrollments[enrollment] = Enrollment.new(attribute)
     end
  end

  def parsed_enrollment_data(file_set)
    EnrollmentParser.new(file_set).district_data
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
