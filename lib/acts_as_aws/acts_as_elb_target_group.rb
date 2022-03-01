module ActsAsAws
  module ActsAsElbTargetGroup
    extend ActiveSupport::Concern
    include Base

    class_methods do
      def acts_as_elb_target_group(**options)
        target_group_arn_attr = options[:target_group_arn_attr] || :elb_target_group_arn
        name_attr = options[:name_attr] || :elb_target_group_name
        vpc_id_attr = options[:vpc_id_attr] || :aws_vpc_id
        protocol_attr = options[:protocol_attr] || :elb_target_group_protocol
        port_attr = options[:port_attr] || :elb_target_group_port
        health_check_path_attr = options[:target_group_health_check_path_attr] || :elb_target_group_health_check_path
        health_check_http_code_attr = options[:target_group_health_check_http_code_attr] || :elb_target_group_health_check_http_code

        acts_as_aws(
          object_type: :elb_target_group,
          client_method: options[:client_method] || :elb_client,
          identifier_attr: target_group_arn_attr,
          creation_params_proc: ->(record) do
            {
              name: record.send(name_attr),
              protocol: record.respond_to?(protocol_attr) ? record.send(protocol_attr) : 'HTTP',
              port: record.respond_to?(port_attr) ? record.send(port_attr) : 80,
              vpc_id: record.send(vpc_id_attr),
              health_check_path: record.respond_to?(health_check_path_attr) ? record.send(health_check_path_attr) : '/',
              matcher: {
                http_code: record.respond_to?(health_check_http_code_attr) ? record.send(health_check_http_code_attr) : '200',
              }
            }.compact
          end,
          creation_proc: ->(client, params) do
            resp = client.create_target_group(params)
            { target_group_arn_attr => resp.target_groups.first.target_group_arn }
          end,
          deletion_proc: ->(client, arn) do
            client.delete_target_group(target_group_arn: arn)
          end,
          presence_proc: ->(client, arn) do
            resp = client.describe_target_groups(target_group_arns: [arn])
            resp.target_groups.length == 1
          end,
          missing_error_class: 'Aws::ElasticLoadBalancingV2::Errors::TargetGroupNotFound',
        )
      end
    end
  end
end
