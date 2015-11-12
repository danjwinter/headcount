require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'parser_repository'
require 'pry'

class DistrictRepository
  attr_accessor :districts, :enrollment_repository

  def initialize
    @districts = {}
  end

  #attributes = {:name=>"Colorado", :kindergarten_participation=>{2007=>0.39465, 2006=>0.33677, 2005=>0.27807}}
  def load_data(file_set)
    enrollment_repo_setup(file_set)
    parsed_district_data(file_set).each do |category_data|
      create_districts_and_enrollment_repo(category_data, file_set)
    end
  end

  def create_districts_and_enrollment_repo(category_data, file_set)
    category_data.each do |district_name, attributes|
      districts[district_name.upcase] = District.new(attributes, enrollment_repository.find_by_name(district_name))
     end
   end

  def enrollment_repo_setup(file_set)
    @enrollment_repository = EnrollmentRepository.new
    @enrollment_repository.load_enrollment_data(file_set)
  end

  def parsed_district_data(file_set)
    ParserRepository.new(file_set).parsed
  end

  def find_by_name(name)
    @districts.key?(name.upcase) ? @districts.fetch(name.upcase) : nil
  end

  def find_all_matching(frag)
    @districts.values.find_all do |district|
      district.name.include?(frag.upcase)
    end
  end

end
