require_relative 'enrollment_parser'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  attr_accessor :enrollments

  def initialize
    @enrollments = {}
  end

  def path(file_set)
    file_set.fetch(:kindergarten)
  end

  def load_data(file_set)

    parsed_enrollment_data(file_set).each_pair do |enrollment, attributes|
      enrollments_data = {}
      enrollments_data[:name] = attributes[0].fetch(:location).upcase

      enrollments_data[:kindergarten_participation] = kindergarten_participation_prep(attributes)
      binding.pry
      enrollments[enrollment] = Enrollment.new(enrollments_data)
     end
  end

  def kindergarten_participation_prep(attributes)
    kind_par = {}
    attributes.each do |attribute|
      kind_par[attribute.fetch(:timeframe)] = attribute.fetch(:data)
    end
    kind_par
  end


  def parsed_enrollment_data(file_set)
    EnrollmentParser.new(path(file_set)).enrollment_data
  end

  def find_by_name(name)
    @enrollments.key?(name) ? @enrollments.fetch(name) : nil
  end

  def find_all_matching(frag)
    @enrollments.values.find_all do |enrollment|
      enrollment.name.include?(frag.upcase)
    end
  end
end
