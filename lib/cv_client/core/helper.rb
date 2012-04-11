require 'date'
class Time
  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  class << self
    # Return the number of days in the given month.
    # If no year is specified, it will use the current year.
    def days_in_month(month, year = now.year)
      return 29 if month == 2 && ::Date.gregorian_leap?(year)
      COMMON_YEAR_DAYS_IN_MONTH[month]
    end
  end
  
  # Returns a new Time representing the end of the month (end of the last day of the month)
  def end_of_month
    #self - ((self.mday-1).days + self.seconds_since_midnight)
    last_day = ::Time.days_in_month(month, year)
    change(:day => last_day, :hour => 23, :min => 59, :sec => 59, :usec => 0)
  end
  
  # Returns a new Time where one or more of the elements have been changed according to the +options+ parameter. The time options
  # (hour, min, sec, usec) reset cascadingly, so if only the hour is passed, then minute, sec, and usec is set to 0. If the hour and
  # minute is passed, then sec and usec is set to 0.
  def change(options)
    ::Time.utc(
      options[:year]  || year,
      options[:month] || month,
      options[:day]   || day,
      options[:hour]  || hour,
      options[:min]   || (options[:hour] ? 0 : min),
      options[:sec]   || ((options[:hour] || options[:min]) ? 0 : sec),
      options[:usec]  || ((options[:hour] || options[:min] || options[:sec]) ? 0 : usec)
    )
  end

end