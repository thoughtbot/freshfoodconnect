class Weekday
  def self.all
    Date::DAYNAMES.map do |wday|
      new(
        label: wday,
        value: Date::DAYNAMES.index(wday),
      )
    end
  end

  def self.find(wday)
    all[wday]
  end

  attr_reader :label, :value

  def initialize(label:, value:)
    @label = label
    @value = value
  end

  def to_s
    label
  end
end
