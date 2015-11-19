require_relative './district_repository'
require 'pry'

class InsufficientInformationError < StandardError
  def message
    "A grade must be provided to answer this question."
  end
end

class UnknownDataError < StandardError

  # attr_reader :requested_grade
  # def initialize(requested_grade)
  #   @requested_grade = requested_grade
  # end
  # def message
  #   "#{requested_grade} is not a known grade."
  # end
end

class HeadcountAnalyst

  attr_reader :dr

  def initialize(district_repository)
    @dr = district_repository
  end

  def truncate(value)
    ((value * 1000).floor/1000.0)
  end

  def kindergarten_participation_rate_variation(district1_name, compare_opts)
    d1 = dr.find_by_name(district1_name)
    d2 = dr.find_by_name(compare_opts[:against])
    average_d1 = average_participation(d1, "kind")
    average_d2 = average_participation(d2, "kind")
    rate_variation_data_guard(average_d1, average_d2)
  end

  def hs_graduation_rate_variation(district1_name, compare_opts)
    d1 = dr.find_by_name(district1_name)
    d2 = dr.find_by_name(compare_opts[:against])
    average_d1 = average_participation(d1, "hs")
    average_d2 = average_participation(d2, "hs")
    rate_variation_data_guard(average_d1, average_d2)
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    # binding.pry
    kprv = kindergarten_participation_rate_variation(district_name, :against => 'COLORADO')
    hsgr = hs_graduation_rate_variation(district_name, :against => 'COLORADO')
    # binding.pry

    unless hsgr == 0
      truncate(kprv/hsgr)
    end
  end

  def non_co_district_names
    non_co_district_names = dr.d_records.keys - ["COLORADO"]
  end

  # def kindergarten_participation_correlates_with_high_school_graduation(for_district_name)
  #   # {:for => "Adams 14"} -> get that 1
  #   # {:for => "Colorado"} -> add up all
  #   #   -> {:across => everything that is not colorado}
  #   # {:across => ["d1", "d2"]}
  #   district_name = for_district_name[:for]
  #   if district_name && district_name.upcase == "COLORADO"
  #      kindergarten_participation_correlates_with_high_school_graduation(across: non_co_district_names)
  #   elsif for_district_name.keys == [:across]
  #     dists = for_district_name[:across]
  #     matching_count = dists.select do |dname|
  #       kindergarten_participation_correlates_with_high_school_graduation(for: dname)
  #     end.count
  #     matching_count.to_f / dists.count.to_f >= 0.7
  #   else
  #     kind_to_hs_variation = kindergarten_participation_against_high_school_graduation(district_name)
  #     (0.6..1.5).include?(kind_to_hs_variation)
  #   end
  # end

  def kindergarten_participation_correlates_with_high_school_graduation(for_district_name)
    # if for_district_name[:for] == "STATEWIDE"
    #   multiple_district_kind_par_with_high_grad(for_district_name)
    # else
    #   single_district_kind_par_with_high_grad(for_district_name[:for])
    case for_district_name.keys
    when [:for]
      single_district_kind_par_with_high_grad(for_district_name)
    when [:across]
      multiple_district_kind_par_with_high_grad(for_district_name)
    end
  end

  def single_district_kind_par_with_high_grad(for_district_name)
    district_name = for_district_name[:for]
    if district_name.upcase == "STATEWIDE"
      kindergarten_participation_correlates_with_high_school_graduation(across: non_co_district_names)
    else
      kind_to_hs_variation = kindergarten_participation_against_high_school_graduation(district_name)
      (0.6..1.5).include?(kind_to_hs_variation)
    end
  end

  def multiple_district_kind_par_with_high_grad(for_district_name)
    dists = for_district_name[:across]
    matching_count = dists.select do |dname|
      kindergarten_participation_correlates_with_high_school_graduation(for: dname)
    end.count
    matching_count.to_f / dists.count.to_f >= 0.7
  end


  def rate_variation_data_guard(average_d1, average_d2)
    if average_d1 == "N/A" || average_d2 == "N/A"
      return "N/A"
    else
      truncate(average_d1 / average_d2)
    end
  end

  def kindergarten_participation_rate_variation_trend(district1_name, vs_district2_name )
    d1_yearly_data = district1(district1_name).enrollment.kindergarten_participation_by_year
    d2_yearly_data = district2(vs_district2_name).enrollment.kindergarten_participation_by_year
    d1_yearly_data.each_pair do |key, value|
      d1_yearly_data[key] = truncate((value + d2_yearly_data[key]) / 2)
    end.sort.to_h
  end

  def district1(district1_name)
    dr.find_by_name(district1_name)
  end

  def district2(vs_district2_name)
    dr.find_by_name(vs_district2_name.fetch(:against))
  end

  def average_participation(district, category)
    sum_participation_rate(district, category) / participation_by_year(district, category).length
  end

  def sum_participation_rate(district, category)
    # binding.pry
    participation_by_year(district, category).compact.reduce(:+)
    # participation_by_year(district, category).inject(0.0) do |sum, val|
    #   sum + val
    # end
  end

  def participation_by_year(district_name, category)
    if district_name.nil?
    else
      case category
      when "kind"
        district_name.enrollment.kindergarten_participation_by_year.values
      when "hs"
        district_name.enrollment.graduation_rate_by_year.values
      end
    end
  end

  def raise_error_guard(requested_grade)
    if requested_grade.nil?
      raise InsufficientInformationError
    end
    if ![3, 8].include?(requested_grade)
      raise UnknownDataError(requested_grade)
    end
  end

  def top_statewide_test_year_over_year_growth(grade_subject_opts)
    all = grade_subject_opts[:all]
    multiple_districts = grade_subject_opts[:top]
    requested_grade = grade_subject_opts[:grade]
    requested_subject = grade_subject_opts[:subject]
    weighting = grade_subject_opts[:weighting]

    raise_error_guard(requested_grade)
    if weighting
      return grab_weighted_subjects(requested_grade, weighting)
    elsif multiple_districts.nil? && requested_subject.nil?
      return grab_all_subjects(requested_grade)
    else

    final_growth_stats = dr.statewide_repository.st_records.map do |name, data|
      [name, get_growth(data, requested_grade, requested_subject)]
    end

    final_growth_stats.reject! {|pair| pair[1] == nil}


    stuff = final_growth_stats.sort_by do |pair|
        pair[1]
    end.reverse
    # if requested_subject == :math && requested_grade == 3
    #   binding.pry
    # end

    if multiple_districts
      stuff[0..(multiple_districts-1)]
    elsif all
      stuff
    elsif requested_grade && requested_subject
      stuff[0]
    end
  end

  end

  def grab_weighted_subjects(requested_grade, weighting)

    math_top = top_statewide_test_year_over_year_growth({all: "districts", grade: requested_grade, subject: :math}).sort
    writing_top = top_statewide_test_year_over_year_growth({all: "districts", grade: requested_grade, subject: :writing}).sort
    reading_top = top_statewide_test_year_over_year_growth({all: "districts", grade: requested_grade, subject: :reading}).sort


    all_subject_average = math_top.map.each_with_index do |element, index|
      total_with_weight = ((weighting[:math] * element[1]) + (weighting[:writing] * writing_top[index][1]) + (weighting[:reading] * reading_top[index][1]))

      [element[0], truncate(total_with_weight)]
    end


    sorted_top_districts = all_subject_average.sort_by do |pair|
      pair[1]
    end.reverse

    sorted_top_districts[0]
  end

  def grab_all_subjects(requested_grade)
    math_top = top_statewide_test_year_over_year_growth({all: "districts", grade: requested_grade, subject: :math}).sort
    writing_top = top_statewide_test_year_over_year_growth({all: "districts", grade: requested_grade, subject: :writing}).sort
    reading_top = top_statewide_test_year_over_year_growth({all: "districts", grade: requested_grade, subject: :reading}).sort

    all_subject_average = math_top.map.each_with_index do |element, index|
      writing = writing_top.select {|el| el[0] == element[0]}
      reading = reading_top.select {|el| el[0] == element[0]}
      unless element[0] == nil || element[1] == nil || writing[0] == nil || reading[0] == nil
        [element[0], truncate((element[1] + writing[0][1] + reading[0][1]) / 3)]
      end
    end

    sorted_top_districts = all_subject_average.compact.sort_by do |pair|
      pair[1]
    end.reverse

    sorted_top_districts[0]
  end

  def get_growth(data, requested_grade, requested_subject, x = 0, numbers = [])
    values = data.grade_proficiency[requested_grade].values
    years = data.grade_proficiency[requested_grade].keys
    num_of_years = data.grade_proficiency[requested_grade].values.length

    math_values  = assign_subject_data(values, requested_subject)
    filtered_math_data = filter_set(math_values, years)
    average_set(filtered_math_data)
  end

  def assign_subject_data(values, requested_subject)
    values.map do |year_data|
      year_data[requested_subject]
    end
  end

  def filter_set(math_values, years)
    filtered_math_data = math_values.map.each_with_index do |element, index|
      if element != "N/A"
        [element, years[index]]
      end
    end.compact
  end

  def average_set(filtered_math_data)
    if filtered_math_data.count == 1
      0.0001
    elsif filtered_math_data.count > 1
    (filtered_math_data[-1][0] - filtered_math_data[0][0]) / (filtered_math_data[-1][1] - filtered_math_data[0][1])
    end
  end



end
