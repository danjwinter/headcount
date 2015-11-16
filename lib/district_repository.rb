require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'parser_repository'
require 'pry'

class DistrictRepository
  attr_accessor :d_records, :enrollment_repository, :statewide_repository

  def initialize
    @d_records = {}
  end

  def load_data(file_set)
    district_opts = parsed_district_data(file_set)
    # parsed_district_data(file_set).each do |category_data|
    if district_opts[:enrollment]
      enrollment_repo_setup(district_opts[:enrollment])
    end
    if district_opts[:statewide]
      statewide_repo_setup(district_opts[:statewide])
    end
      create_districts(district_opts)

  end

  def create_districts(district_opts)
    names = district_opts.values.first.first.keys
    #
    names.each do |name|
      if statewide_repository && enrollment_repository
        d_records[name.upcase] ||=  District.new({name: name.upcase, enrollment: enrollment_repository.find_by_name(name.upcase), statewide: statewide_repository.find_by_name(name.upcase)})
      elsif statewide_repository
        d_records[name.upcase] ||=  District.new({name: name.upcase, enrollment: nil, statewide: statewide_repository.find_by_name(name.upcase)})
      elsif enrollment_repository
        d_records[name.upcase] ||=  District.new({name: name.upcase, enrollment: enrollment_repository.find_by_name(name.upcase), statewide: nil})
      end
   end
 end

 def statewide_repo_setup(category_data)

   @statewide_repository ||= StatewideTestRepository.new
   @statewide_repository.load_statewide_data(category_data)
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

end
