class Hour
  def self.count
    23
  end

  def self.all
    (0..count).map do |hour|
      new(
        label: I18n.t("date.hours")[hour],
        value: hour,
      )
    end
  end

  def self.find(hour)
    all[hour]
  end

  attr_reader :label, :value

  def initialize(label:, value:)
    @label = label
    @value = value
  end
end
