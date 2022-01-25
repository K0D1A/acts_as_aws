module ActsAsAws
  module ActsAsAwsClient
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_acm_client(**options)
        acts_as_aws_client(method: :acm_client, class: 'Aws::ACM::Client')
      end

      def acts_as_ec2_client(**options)
        acts_as_aws_client(method: :ec2_client, class: 'Aws::EC2::Client')
      end

      def acts_as_elb_client(**options)
        acts_as_aws_client(method: :elb_client, class: 'Aws::ElasticLoadBalancingV2::Client')
      end

      def acts_as_rds_client(**options)
        acts_as_aws_client(method: :rds_client, class: 'Aws::RDS::Client')
      end

      private

      def acts_as_aws_client(**options)
        method = options[:method] or raise 'missing method'
        var_name = :"@#{method}"
        client_class_name = options[:class] or raise 'missing class'
        client_class = client_class_name.constantize
        region_attr = options[:region_attr] || :aws_region
        credentials_attr = options[:credentials_attr] || :aws_credentials

        define_method method do
          if instance_variable_defined?(var_name) && (value = instance_variable_get(var_name))
            return value
          end

          region = send(region_attr)
          credentials = send(credentials_attr)
          instance_variable_set var_name, client_class.new(region: region, credentials: credentials)
        end
      end
    end
  end
end
