# Moneta::Encryptor

The gem provides a simple symmetric encryption layer to the Moneta chain.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moneta-encryptor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moneta-encryptor

## Usage

```
  require 'moneta/encryptor'

  Moneta.build do
    use :Encryptor, encryption_key: 'SECRET' * 6
    adapter :Memory
  end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anakinj/moneta-encryptor.

