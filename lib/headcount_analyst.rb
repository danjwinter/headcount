require_relative './district_repository'
require 'pry'

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
    kprv = kindergarten_participation_rate_variation(district_name, :against => 'COLORADO')
    hsgr = hs_graduation_rate_variation(district_name, :against => 'COLORADO')
    truncate(kprv/hsgr)
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
    case for_district_name.keys
    when [:for]
      single_district_kind_par_with_high_grad(for_district_name)
    when [:across]
      multiple_district_kind_par_with_high_grad(for_district_name)
    end
  end

  def single_district_kind_par_with_high_grad(for_district_name)
    district_name = for_district_name[:for]
    if district_name.upcase == "COLORADO"
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
    participation_by_year(district, category).inject(0.0) do |sum, val|
      sum + val
    end
  end

  def participation_by_year(district_name, category)
    case category
    when "kind"
      district_name.enrollment.kindergarten_participation_by_year.values
    when "hs"
      district_name.enrollment.graduation_rate_by_year.values
    end
  end

  def top_statewide_test_year_over_year_growth(grade_subject_opts)
    multiple_districts = grade_subject_opts[:top]
    requested_grade = grade_subject_opts[:grade]
    requested_subject = grade_subject_opts[:subject]
    weighting = grade_subject_opts[:weighting]

    if weighting
      return grab_weighted_subjects(requested_grade, weighting)
    elsif multiple_districts.nil? && requested_subject.nil?
      return grab_all_subjects(requested_grade)
    else

    final_growth_stats = dr.statewide_repository.st_records.map do |name, data|
      [name, get_growth(data, requested_grade, requested_subject)]
    end

    stuff = final_growth_stats.sort_by do |pair|
      pair[1]
    end.reverse

    if multiple_districts
      stuff[0..(multiple_districts-1)]
    elsif requested_grade && requested_subject
      stuff[0]
    end
  end

  end

  def grab_weighted_subjects(requested_grade, weighting)
    math_weight = weighting[:math]
    reading_weight = weighting[:reading]
    writing_weight = weighting[:writing]

    math_top = top_statewide_test_year_over_year_growth({grade: requested_grade, subject: :math})
    writing_top = top_statewide_test_year_over_year_growth({grade: requested_grade, subject: :writing})
    reading_top = top_statewide_test_year_over_year_growth({grade: requested_grade, subject: :reading})

    math_top[1] *= math_weight
    writing_top[1] *= writing_weight
    reading_top[1] *= reading_weight

    top_districts = ([math_top] + [writing_top] + [reading_top])

    sorted_top_districts = top_districts.sort_by do |pair|
      pair[1]
    end.reverse
    sorted_top_districts[0]
  end

  def grab_all_subjects(requested_grade)
    math_top = top_statewide_test_year_over_year_growth({grade: requested_grade, subject: :math})
    writing_top = top_statewide_test_year_over_year_growth({grade: requested_grade, subject: :writing})
    reading_top = top_statewide_test_year_over_year_growth({grade: requested_grade, subject: :reading})

    top_districts = ([math_top] + [writing_top] + [reading_top])

    sorted_top_districts = top_districts.sort_by do |pair|
      pair[1]
    end.reverse
    sorted_top_districts[0]
  end

  def get_growth(data, requested_grade, requested_subject, x = 0, numbers = [])

    values = data.grade_proficiency[requested_grade].values
    num_of_years = data.grade_proficiency[requested_grade].values.length
    math_values = values.map do |year_data|
      year_data[requested_subject]
    end

    hopeful = math_values.map.each_with_index do |num, index|
      unless math_values[index + 1] == nil
        math_values[index + 1] - num
      end
    end
    total = hopeful.compact.reduce(:+)
    truncate(total / (num_of_years - 1))
  end



  # get growth for all subjects
  # pass in each subject and create an darray with three arrays that coordinate with each suhbject, for each District
  # iteration will match up for each district and subject
  # join then grab top
  # for weighted data - create a hash with subject as key and districts as values

end
