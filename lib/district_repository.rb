require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'parser_repository'
require 'pry'

class DistrictRepository
  attr_accessor :d_records, :enrollment_repository

  def initialize
    @d_records = {}
  end

  def load_data(file_set)
    parsed_district_data(file_set).each do |category_data|
      enrollment_repo_setup(category_data)
      create_districts(category_data, file_set)
    end
  end

  def create_districts(category_data, file_set)
    category_data.each do |district_name, attributes|
        d_records[district_name.upcase] ||=  District.new(attributes, enrollment_repository.find_by_name(district_name))
   end
 end

  def enrollment_repo_setup(category_data)
    @enrollment_repository ||= EnrollmentRepository.new
    @enrollment_repository.load_enrollments(category_data)
  end

  def parsed_district_data(file_set)
    ParserRepository.new(file_set).parsed
  end

  def find_by_name(name)
    @d_records.key?(name.upcase) ? @d_records.fetch(name.upcase) : nil
  end

  def find_all_matching(frag)
    @d_records.values.find_all do |district|
      district.name.include?(frag.upcase)
    end
  end

  def load_districts(category_data)
    category_data.each_pair do |district, attribute|
      binding.pry
      if d_records[district].nil?
        d_records[district] = District.new(attribute, enrollment_repository.find_by_name(district.upcase))
      end
    end
  end

  def load_district_data(file_set)
    parsed_district_data(file_set).each do |category_data|
      load_districts(category_data)
    end
  end

  def load_attributes(attribute)
    d_records[district] = District.new(attribute)
  end

end
