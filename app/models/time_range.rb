class TimeRange
  def initialize(start_at:, end_at:)
    @start_at = start_at
    @end_at = end_at
  end

  def to_s
    I18n.t(
      "time_ranges.format",
      date: I18n.l(date, format: :long_with_weekday),
      start_at: format(start_at),
      end_at: format(end_at),
    )
  end

  private

  FORMAT = "%l:%M %P".freeze

  private_constant :FORMAT

  attr_reader :start_at, :end_at

  def format(datetime)
    datetime.strftime(FORMAT).strip
  end

  def date
    start_at.to_date
  end
end
