require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'parser_repository'
require_relative 'economic_profile_repository'

class DistrictRepository
  attr_accessor :d_records, :enrollment_repository, :statewide_repository, :economic_repository

  def initialize
    @d_records = {}
    @statewide_repository = StatewideTestRepository.new
    @enrollment_repository = EnrollmentRepository.new
    @economic_repository = EconomicProfileRepository.new
  end

  def load_data(file_set)
    district_opts = parsed_district_data(file_set)
    load_repos(district_opts)
    create_districts(district_opts)
  end

  def load_repos(district_opts)
    load_enrollment_repo(district_opts)
    load_statewide_repo(district_opts)
    load_economic_repo(district_opts)
  end

  def load_statewide_repo(district_opts)
    if district_opts[:statewide]
      statewide_repo_setup(district_opts[:statewide])
    end
  end

  def load_economic_repo(district_opts)
    if district_opts[:economic_profile]
      economic_repo_setup(district_opts[:economic_profile])
    end
  end

  def load_enrollment_repo(district_opts)
    if district_opts[:enrollment]
      enrollment_repo_setup(district_opts[:enrollment])
    end
  end

  def create_districts(district_opts)
    names = district_opts.values.first.first.keys
    names.each do |name|
       d_records[name.upcase] ||=  District.new({name: name.upcase})
       d_records[name.upcase].load_info({enrollment: enrollment_repository.find_by_name(name.upcase), statewide: statewide_repository.find_by_name(name.upcase), economic: economic_repository.find_by_name(name.upcase)})
   end
 end

 def statewide_repo_setup(category_data)
   @statewide_repository.load_statewide_info(category_data)
 end

  def enrollment_repo_setup(category_data)
    @enrollment_repository.load_enrollments(category_data)
  end

  def economic_repo_setup(category_data)
    @economic_repository.load_economic_info(category_data)
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
