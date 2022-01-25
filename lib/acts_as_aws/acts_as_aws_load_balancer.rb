module ActsAsAws
  module ActsAsAwsLoadBalancer
    extend ActiveSupport::Concern
    include Base

    class_methods do
      def acts_as_aws_load_balancer(**options)
        arn_attr = options[:arn_attr] || :aws_load_balancer_arn
        name_attr = options[:name_attr] || :name
        hostname_attr = options[:hostname_attr] || :hostname
        subnets_method = options[:subnets_method] || :aws_load_balancer_subnets
        security_groups_method = options[:security_groups_method]

        validate(on: :create) do
          errors.add :base, 'must have at least two subnets defined' unless send(subnets_method).length >= 2
        end

        acts_as_aws(
          object_type: :aws_load_balancer,
          client_method: options[:client_method] || :elb_client,
          identifier_attr: arn_attr,
          creation_params_proc: ->(record) do
            {
              name: record.send(name_attr),
              subnets: subnets_method ? record.send(subnets_method) : nil,
              security_groups: security_groups_method ? record.send(security_groups_method) : nil,
            }.compact
          end,
          creation_proc: ->(client, params) do
            resp = client.create_load_balancer(params)
            lb = resp.load_balancers.first
            {
              arn_attr => lb.load_balancer_arn,
              hostname_attr => lb.dns_name,
            }
          end,
          deletion_proc: ->(client, arn) do
            client.delete_load_balancer(load_balancer_arn: arn)
          end,
          presence_proc: ->(client, arn) do
            resp = client.describe_load_balancers(load_balancer_arns: [arn])
            resp.load_balancers.length == 1
          end,
          missing_error_class: 'Aws::ElasticLoadBalancingV2::Errors::LoadBalancerNotFound',
        )
      end
    end
  end
end
