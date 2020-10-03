require 'cgi'

# Implement tags to reproduce the common "content_for" functionality:
#
# ContentFor   / content_for    - Record a block of content in a page to be used by the layout
# YieldContent / yield_content  - Output captured content in a layout
# IfContentFor / if_content_for - Test if content was captured
#
# Depends on LiquidMMExtension

# Implements content_for. Usage:
#
#     {% content_for name %}
#       ...
#     {% end_content_for %}
#
# Example:
#
#     {% content_for description %}
#       Content to capture goes here
#       You can use filters here: {{ user.name | escape }}
#       And tags:
#       {% for page in pages %}
#         {{ page.title }}
#       {% endfor %}
#     {% end_content_for %}
#
# Will capture content with the name "description". You will then be able to emit this content
# with {% yield_content description %}
class ContentFor < Liquid::Block
  SYNTAX_HELP = "Syntax Error in tag 'content_for' - Valid syntax: {% content_for name %}".freeze

  def initialize(tag_name, markup, parse_context)
    params = markup.split(/\s+/)
    raise SyntaxError, SYNTAX_HELP unless params.length == 1
    @name = params.first
    super(tag_name, markup, parse_context)
  end

  def render(context)
    content_for = context.environments.first['middleman'].instance_variable_get('@content_for')
    if content_for.nil?
      content_for = {}
      context.environments.first['middleman'].instance_variable_set('@content_for', content_for)
    end
    content_for[@name] = @body.render(context)
    # byebug
    ''
  end

  def block_delimiter
    "end_#{block_name}"
  end
end

Liquid::Template.register_tag('content_for', ContentFor)

# Implements yield_content. Usage:
#
#     {% yield_content name [escape] %}
#
# Example:
#
#     {% yield_content description %}
#
# Will yield content with the name "description".
#
# Escaping:
#
#     {% yield_content title escape %}
#
# Will yield content with the name "escape" and HTML escape it
class YieldContent < Liquid::Tag
  SYNTAX_HELP = "Syntax Error in tag 'yield_content' - Valid syntax: {% yield_content name [escape] %}".freeze

  def initialize(tag_name, markup, parse_context)
    params = markup.split(/\s+/)
    raise SyntaxError, SYNTAX_HELP unless params.length == 1 || params.length == 2
    @name = params.first
    @escape = false
    if params[1]
      if params[1] == 'escape'
        @escape = true
      else
        raise SyntaxError, SYNTAX_HELP
      end
    end
    super(tag_name, markup, parse_context)
  end

  def render(context)
    content_for = context.environments.first['middleman'].instance_variable_get('@content_for')
    content = content_for[@name] || ''
    if @escape
      CGI.escapeHTML(content)
    else
      content
    end
  end
end

Liquid::Template.register_tag('yield_content', YieldContent)

# Implements if_content_for. Usage:
#
#     {% if_content_for description %}
#       ...
#     {% end_if_content_for %}
#
# This is useful if you want to emit some optional captured content with some outer structure, and only
# want to emit that outer structure at all if there is some content registered.
#
# Example:
#
#     {% if_content_for description %}
#       <div class="description">
#         {% yield_content description escape}
#       </div>
#     {% end_if_content_for %}
#
# Will only output the content within it if there is some content for the name "description"
class IfContentFor < Liquid::Block
  def initialize(tag_name, markup, parse_context)
    params = markup.split(/\s+/)
    raise SyntaxError, SYNTAX_HELP unless params.length == 1
    @name = params.first
    super(tag_name, markup, parse_context)
  end

  def render(context)
    content_for = context.environments.first['middleman'].instance_variable_get('@content_for')
    if content_for&.dig(@name)
      @body.render(context)
    else
      ''
    end
  end

  def block_delimiter
    "end_#{block_name}"
  end
end

Liquid::Template.register_tag('if_content_for', IfContentFor)
