class InsufficientInformationError < StandardError
  def message
    "A grade must be provided to answer this question."
  end
end

class UnknownDataError < StandardError
end

class UnknownRaceError < StandardError
end
