class EconomicProfile

  attr_reader :median_household_income, :children_in_poverty, :free_or_reduced_price_lunch, :title_i, :median_household_income_with_range

  def initialize(data)
    @median_household_income ||= data[:median_household_income]
    @median_household_income_with_range ||= data[:median_household_income].map {|k,v| [k[0]..k[1], v]}.to_h
    @children_in_poverty ||= data[:children_in_poverty]
    @free_or_reduced_price_lunch ||= data[:free_or_reduced_price_lunch]
    @title_i ||= data[:title_i]
  end

  def median_household_income_in_year(year)
    income = median_household_income_with_range.select do |k,v|
      k.include?(year)
    end.values

    if income.length > 1
      income.reduce(:+) / income.length
    else
      income[0]
    end
  end

  def median_household_income_average
    incomes = median_household_income.values
    incomes.reduce(:+) / incomes.length
  end

end