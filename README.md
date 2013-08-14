# Cohabit

Cohabit adds comprehensive scoped multi-tenancy functionality to any application, simply set your options up in `config/cohabit.rb` using the DSL (inspired by capistrano).

This gem isn't really recommended for doing simple application wide scoping, for that I'd recommend https://github.com/wireframe/multitenant. Cohabit builds on what `multitenant` provides and allows you to define your own scoping strategies with the DSL for where more complexity is needed.

It provides (or it will):

- Model scoping (duh)
- Custom scoping strategies
- Scope validations
- Scope URL helpers
- Rake task for importing single-tenanted databases into a multi-tenant one
- Rake task for generating multi-tenanted scoped schema

## Installation

Add this line to your application's Gemfile:

    gem 'cohabit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cohabit

## Usage

In its simplest form, using the basic scope (typical `belongs_to` assiciation scope):
    
    # must have this line to use the included scopes
    require 'basic'
    scope [:foo, :bar], :basic

By default it assumes your tenant model is called tenant, if you wish to change this you can set it globally:

    set :association, :organisation
    scope [:foo, :bar], :basic

Or per scope with options:

    scope [:foo, :bar], :basic, association: :organisation

Or you can specify options and other configuration settings in block form:

    scope [:foo, :bar] do
      use_strategy: :basic
      set :association, :organisation
    end

In your application, depending on how you determine the current tenant, you need to set `Cohabit.current_tenant`. If you're using subdomains, I would recommend writing some simple Rack middleware something like:

    class TenantSetup
      def initialize(app)
        @app = app
      end

      def call(env)
        @request = Rack::Request.new(env)
        Cohabit.current_tenant = Tenant.find_by_subdomain!(get_subdomain)
        @app.call(env)
      end

      private
        def get_subdomain
          # Check request host isn't an IP.
          host = @request.host
          return nil unless !(host.nil? || /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
          subdomain = host.split('.')[0..-3].first
          return subdomain unless subdomain == "www"
          return host.split('.')[0..-3][1]
        end
    end

Alternatively, write a `before_filter` in the `ApplicationController`.

### Strategies

This part is a WIP, but you can define your own strategies to be used. The following is the :basic strategy that comes by default:

    strategy :basic do
      # simply gets evaluated in the models..
      model_eval do |_scope|
        # _scope var references the scope that uses the strategy,
        # so to access settings, like :association, use
        # _scope.settings[:association]. current_tenant is defined
        # as Cohabit.current_tenant.

        # add relationship
        belongs_to _scope.settings[:association]

        # get foreign key
        reflection = reflect_on_association _scope.settings[:association]

        # scope insertions
        before_create Proc.new {|m|
          return unless Cohabit.current_tenant
          m.send "#{_scope.settings[:association]}=".to_sym, Cohabit.current_tenant
        }

        # scope selects
        default_scope lambda {
          where(reflection.foreign_key => Cohabit.current_tenant) if Cohabit.current_tenant
        }
      end
    end

You can define additional global vars in the Cohabit namespace, in your strategies, e.g.:

    strategy :test do
      set :globals, [:current_view, :current_scope]
      # ...
    end

    # application_controller.rb
    before_filter :set_scope
    def set_scope
      Cohabit.current_scope = Cohabit.current_tenant.managed_clients
    end

You can also nest strategies to DRY up your code a bit.

    strategy :basic_tweaked do
      include_strategy :basic
      model_eval do |_scope|
        # ...
      end
    end

### Settings

Once I've implemented it, you'll be able to scope URL helpers, so for example if your tenant features in your URL like so:

    # routes file
    # ...
    resources :tenants do
      resources :posts
      resources :foo
      resources :bar
    end
    # ...

Giving you the paths `/tenant/1/posts/1` .. etc. You will be able to still call `posts_path(@post)`, and when the setting is enabled it will expand that internally to `tenants_posts_path(@post.tenant, @post)`.

### Rake tasks

There are two rake tasks in the pipeline to make life a bit easier for anyone converting from multi-database architecture to a multi-tenant, single-database architecture:

1. Migrate DB or create new DB schema based on the scopes in a cohabit configuration file
2. Import a number of single-tenanted databases into the multi-tenanted equivalent

## Todo

Still a WIP. Need to:

- Work out how to integrate the url helper scopes as an option
- Write the rake tasks
- Add custom `cohabit_unscoped` (or similar) class method to models which removes all Cohabit `default_scope`s, `before_create`s, validation scopes, etc for that chain. (Possible? hmf)
- Add a `conditions` option to `include_strategy`, like that of Rails routes perhaps

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
