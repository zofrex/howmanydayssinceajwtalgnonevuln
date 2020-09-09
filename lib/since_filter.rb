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
