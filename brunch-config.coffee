


exports.config =
  # See http://brunch.io/#documentation for docs.
  files:
    javascripts:
      joinTo:
        'learn-shaders.js': /^app/
        'learn-shaders.tests.js': /^test/
        'learn-shaders.vendor.js': /^bower_components/

    stylesheets:
      joinTo: 'learn-shaders.css'
#
  modules:
    definition: 'amd'
    wrapper: 'amd'

  paths:
    public: 'build'

  overrides:
    production:
      sourceMaps: true

  plugins:
    coffeelint:
      pattern:
        test: (path) -> /^(app|test)\/.*\.coffee$/.test(path)
      options:
        no_unnecessary_double_quotes:
          level: 'error'
        no_interpolation_in_single_quotes:
          level: 'error'
        prefer_english_operator:
          level: 'error'
        space_operators:
          level: 'error'
        spacing_after_comma:
          level: 'error'
        no_implicit_returns:
          module: 'coffeelint-no-implicit-returns'
        max_line_length:
          value: 200
