module SinceHelper
  def days_since_in_words(input)
    days = (Date.today - input).to_i
    if days == 1
      "1 day"
    else
      "#{days} days"
    end
  end
end
