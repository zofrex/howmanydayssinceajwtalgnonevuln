# Make stylesheet_link_tag helper available to Liquid templates
# Depends on LiquidMMExtension

# Implements stylesheet_link_tag. Usage:
#
#     {% stylesheet_link_tag stylesheet_name %}
#
# Example:
#
#     {% stylesheet_link_tag article %}
#
# Produces a link tag like:
#
#     <link href="/stylesheets/article.css" rel="stylesheet" />
class StylesheetLinkTag < Liquid::Tag
  SYNTAX_HELP = "Syntax Error in tag 'stylesheet_link_tag' - Valid syntax: {% stylesheet_link_tag stylesheet_name %}".freeze

  def initialize(tag_name, markup, parse_context)
    params = markup.split(/\s+/)
    raise SyntaxError, SYNTAX_HELP unless params.length == 1
    @sheet = params.first
    super(tag_name, markup, parse_context)
  end

  def render(context)
    app = context.environments.first['middleman']
    app.stylesheet_link_tag @sheet
  end
end

Liquid::Template.register_tag('stylesheet_link_tag', StylesheetLinkTag)
