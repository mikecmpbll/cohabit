# Cohabit

Cohabit adds comprehensive scoped multi-tenancy functionality to any application, simply set your options up in `config/cohabit.rb` using the DSL (inspired by capistrano).

It adds:

- Model scoping (duh)
- Custom scoping strategies
- Scope validations
- Scope URL helpers
- Rake task for importing single-tenanted databases into a multi-tenant one
- Rake task for generating multi-tenanted scoped schema

## Todo

Still a WIP. Need to:

- Develop snippets to be included in strategies, i.e. scope_validations snippet (and remove that setting)
- Should snippets just be nested strategies? wah, probably.
- Work out how to integrate the url helper scopes as an option
- Write the rake tasks

## Installation

Add this line to your application's Gemfile:

    gem 'cohabit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cohabit

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
