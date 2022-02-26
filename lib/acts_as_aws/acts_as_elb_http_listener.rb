module ActsAsAws
  module ActsAsElbHttpListener
    extend ActiveSupport::Concern
    include Base

    class_methods do
      def acts_as_elb_http_listener(**options)
        load_balancer_arn_attr = options[:load_balancer_arn_attr] || :aws_load_balancer_arn
        listener_arn_attr = options[:listener_arn_attr] || :elb_http_listener_arn
        port_attr = options[:port_attr] || :elb_http_listener_port

        acts_as_aws(
          object_type: :elb_http_listener,
          client_method: options[:client_method] || :elb_client,
          identifier_attr: listener_arn_attr,
          creation_params_proc: ->(record) do
            {
              load_balancer_arn: record.send(load_balancer_arn_attr),
              protocol: 'HTTP',
              port: record.respond_to?(port_attr) ? record.send(port_attr) : 80,
              default_actions: [
                type: 'fixed-response',
                fixed_response_config: {
                  status_code: '503',
                }
              ]
            }
          end,
          creation_proc: ->(client, params) do
            resp = client.create_listener(params)
            { listener_arn_attr => resp.listeners.first.listener_arn }
          end,
          deletion_proc: ->(client, arn) do
            client.delete_listener(listener_arn: arn)
          end,
          presence_proc: ->(client, arn) do
            resp = client.describe_listeners(listener_arns: [arn])
            resp.listeners.length == 1
          end,
          missing_error_class: 'Aws::ElasticLoadBalancingV2::Errors::ListenerNotFound',
        )
      end
    end
  end
end
