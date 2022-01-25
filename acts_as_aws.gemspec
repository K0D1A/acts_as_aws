require_relative 'lib/acts_as_aws/version'

Gem::Specification.new do |spec|
  spec.name        = 'acts_as_aws'
  spec.version     = ActsAsAws::VERSION
  spec.authors     = ['Anthony Wang']
  spec.email       = ['awang@kodia.com']
  spec.summary     = 'AWS Models'
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/K0D1A/acts_as_aws'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'aws-sdk-acm',                    '~> 1'
  spec.add_dependency 'aws-sdk-ec2',                    '~> 1'
  spec.add_dependency 'aws-sdk-elasticloadbalancingv2', '~> 1'
  spec.add_dependency 'aws-sdk-rds',                    '~> 1'
  spec.add_dependency 'rails',                          '~> 6.1'

  spec.add_development_dependency 'dotenv-rails',       '~> 2.7'
end
