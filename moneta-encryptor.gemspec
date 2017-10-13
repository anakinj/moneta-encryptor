lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'moneta-encryptor'
  spec.version       = File.read(File.expand_path('../version', __FILE__)).chomp
  spec.authors       = ['Joakim Antman']
  spec.email         = ['antmanj@gmail.com']

  spec.summary       = 'Moneta transformer that encrypts the values before persisted in the store'
  spec.homepage      = 'https://github.com/anakinj/moneta-encryptor'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'moneta'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
end
