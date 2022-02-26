module ActsAsAws
  module ActsAsAwsLoadBalancer
    extend ActiveSupport::Concern
    include Base

    class_methods do
      def acts_as_aws_load_balancer(**options)
        arn_attr = options[:arn_attr] || :aws_load_balancer_arn
        name_attr = options[:name_attr] || :name
        hostname_attr = options[:hostname_attr] || :hostname
        subnet_ids_attr = options[:subnet_ids_attr] || :aws_load_balancer_subnet_ids
        security_group_ids_attr = options[:security_group_ids_attr] || :aws_load_balancer_security_group_ids

        validate(on: :create) do
          errors.add :base, 'must have at least two subnets defined' unless send(subnet_ids_attr).length >= 2
        end

        acts_as_aws(
          object_type: :aws_load_balancer,
          client_method: options[:client_method] || :elb_client,
          identifier_attr: arn_attr,
          creation_params_proc: ->(record) do
            {
              name: record.send(name_attr),
              subnets: record.respond_to?(subnet_ids_attr) ? record.send(subnet_ids_attr) : nil,
              security_groups: record.respond_to?(security_group_ids_attr) ? record.send(security_group_ids_attr) : nil,
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
