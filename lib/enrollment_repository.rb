require_relative 'kindergarten_enrollment_parser'
require_relative 'enrollment'
require_relative 'parser_repository'
require 'pry'

class EnrollmentRepository
  attr_accessor :e_records

  def initialize
    @e_records = {}
  end

  def load_enrollment_data(enrollment_opts)
    enrollment_opts.each do |enrollment, attribute|
      binding.pry
      enrollment.upcase!
      if e_records[enrollment].nil?
        e_records[enrollment] = Enrollment.new(enrollment)
      end
      e_records[enrollment].load_new_data(attribute)
    end
    #grab keys from opts and iterate through each to create a new enrollment object if one doesn't exist within the e_records
    # take values associated with those enrollment keys and send as attributes to load_new_data for each enrollment

    # parsed_enrollment_data(file_set).each do |category_data|
    #   load_enrollments(category_data)
    # end
  end

  def load_enrollments(enrollment_opts)
    enrollment_opts.each do |enrollments|
      enrollments.each do |enrollment, attribute|
        enrollment = enrollment.upcase
        if e_records[enrollment].nil?
          e_records[enrollment] = Enrollment.new(enrollment)
        end
        e_records[enrollment].load_new_data(attribute)
      end
    end
  end

  def parsed_enrollment_data(file_set)
    ParserRepository.new(file_set).parsed[:enrollment]
  end

  def find_by_name(name)
    @e_records.key?(name.upcase) ? @e_records.fetch(name.upcase) : nil
  end

  def load_data(file_set)
    parsed_enrollment_data(file_set).each do |category_data|
      create_enrollments(category_data, file_set)
    end
  end

  def create_enrollments(category_data, file_set)
    category_data.each do |enrollment_name, attributes|
        e_records[enrollment_name.upcase] ||= Enrollment.new(enrollment_name)
        e_records[enrollment_name.upcase].load_new_data(attributes)
   end
 end
end
