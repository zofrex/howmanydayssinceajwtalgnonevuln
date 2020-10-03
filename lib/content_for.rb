require 'cgi'

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
