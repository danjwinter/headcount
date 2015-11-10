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
    average_d1 = average_kindergarten_participation(district1(district1_name))
    average_d2 = average_kindergarten_participation(district2(vs_district2_name))
    truncate(average_d1 / average_d2)
  end

  def district1(district1_name)
    dr.find_by_name(district1_name)
  end

  def district2(vs_district2_name)
    dr.find_by_name(vs_district2_name.fetch(:against))
  end

  def average_kindergarten_participation(district)
    sum_participation_rate(district) / participation_by_year(district).length
  end

  def sum_participation_rate(district)
    participation_by_year(district).inject(0.0) do |sum, val|
      sum + val
    end
  end

  def participation_by_year(district_name)
    # binding.pry
    district_name.enrollment.kindergarten_participation_by_year.values
  end


end
