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

  def kindergarten_participation_rate_variation(district1_name, vs_district2_name )
    average_d1 = average_participation(district1(district1_name), "kind")
    average_d2 = average_participation(district2(vs_district2_name), "kind")
    rate_variation_data_guard(average_d1, average_d2)
  end

  def hs_graduation_rate_variation(district1_name, vs_district2_name)
    average_d1 = average_participation(district1(district1_name), "hs")
    average_d2 = average_participation(district2(vs_district2_name), "hs")
    rate_variation_data_guard(average_d1, average_d2)
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kprv = kindergarten_participation_rate_variation(district_name, :against => 'COLORADO')
    hsgr = hs_graduation_rate_variation(district_name, :against => 'COLORADO')
    truncate(kprv/hsgr)
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
    final_yearly_data = {}
    d1_yearly_data.each_pair do |key, value|
      final_yearly_data[key] = truncate((value + d2_yearly_data[key]) / 2)
    end
    final_yearly_data.sort.to_h
    # d1_yearly_data.each do |k, v|
    #   d1_yearly_data[k] = truncate((v + d2_yearly_data[k]) / 2)
    # end
    # d1_yearly_data
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





end
