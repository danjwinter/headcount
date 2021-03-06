require_relative 'custom_errors'

class EconomicProfile

  attr_reader :median_household_income, :children_in_poverty, :free_or_reduced_price_lunch, :title_i, :median_household_income_with_range, :name

  def initialize(data)
    @median_household_income ||= data[:median_household_income]
    @median_household_income_with_range ||= data[:median_household_income].map {|k,v| [k[0]..k[1], v]}.to_h
    @children_in_poverty ||= data[:children_in_poverty]
    @free_or_reduced_price_lunch ||= data[:free_or_reduced_price_lunch]
    @title_i ||= data[:title_i]
    @name ||= data[:name]
  end

  def estimated_median_household_income_in_year(year)
    income = income_amounts(year)
    aggregate(income)
  end

  def aggregate(income)
    if income.length > 1
      income.reduce(:+) / income.length
    else
      income[0]
    end
  end

  def income_amounts(year)
    median_household_income_with_range.select do |k,v|
      k.include?(year)
    end.values
  end

  def median_household_income_average
    incomes = median_household_income.values
    incomes.reduce(:+) / incomes.length
  end

  def children_in_poverty_in_year(year)
    truncate(@children_in_poverty[year])
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if free_or_reduced_price_lunch.keys.include?(year)
      truncate(free_or_reduced_price_lunch[year][:percentage])
    else
      raise UnknownDataError
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if free_or_reduced_price_lunch.keys.include?(year)
      truncate(free_or_reduced_price_lunch[year][:total])
    else
      raise UnknownDataError
    end
  end

  def title_i_in_year(year)
    if title_i.keys.include?(year)
      truncate(title_i[year])
    else
      raise UnknownDataError
    end
  end

  def truncate(value)
    ((value * 1000).floor/1000.0)
  end
end
