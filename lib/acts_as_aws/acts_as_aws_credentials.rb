module ActsAsAws
  module ActsAsAwsCredentials
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_aws_credentials(**options)
        method = options[:method] || :aws_credentials
        var_name = :"@#{method}"
        access_key_attr = options[:access_key_attr] || :aws_access_key
        secret_key_attr = options[:secret_key_attr] || :aws_secret_key

        define_method method do
          if instance_variable_defined?(var_name) && (value = instance_variable_get(var_name))
            return value
          end

          access_key = send(access_key_attr)
          secret_key = send(secret_key_attr)
          instance_variable_set var_name, Aws::Credentials.new(access_key, secret_key)
        end
      end
    end
  end
end
