# Implements since. Usage:
#
#     {{ some_date | since }}
#
# This will produce "1 day" if the date is 1 day in the past, and "<x> days" for other numbers.
module SinceFilter
  def since(input)
    days = (Date.today - input).to_i
    if days == 1
      "1 day"
    else
      "#{days} days"
    end
  end
end

Liquid::Template.register_filter(SinceFilter)
