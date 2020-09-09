module LiquidMMExtension
  def evaluate(scope, locals, &block)
    # cram 'scope' into middleman so that:
    #  CssTag can access the middleman functions
    #  ContentFor has somewhere to smuggle state between views
    # create current_page hash structure so that current_page.data.foo works as expected
    locals = locals.merge({middleman: scope, current_page: {'data' => scope.current_page.data }})
    super(scope, locals, &block)
  end
end

class Tilt::LiquidTemplate < Tilt::Template
  prepend LiquidMMExtension
end
