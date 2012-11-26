require "sprockets"
require "tilt"

module Handlebars
  class << self
    def registered(app)
      app.inst.template_extensions handlebars: :js, hbs: :js
      ::Tilt.register HandlebarsTemplate, 'handlebars', 'hbs'
      ::Sprockets.register_engine ".hbs", HandlebarsTemplate
    end
    alias :included :registered
  end

  class HandlebarsTemplate < Tilt::Template
    def self.engine_initialized?
      defined? ::Steering
    end

    def initialize_engine
      require_template_library 'steering'
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      name = file.match(/source\/javascripts\/templates\/(.*)\.js\.hbs/i)[1]
      out = "\nEmber.TEMPLATES = Ember.TEMPLATES || {};"
      out += "\nEmber.TEMPLATES['#{name}'] = Ember.Handlebars.template(#{::Steering.compile(data)});\n"
      @output ||= out
    end

    def allows_script?
      false
    end
  end
end

Middleman::Extensions.register :handlebars, Handlebars