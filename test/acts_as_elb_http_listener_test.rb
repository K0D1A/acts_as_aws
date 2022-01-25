require 'test_helper'

module ActsAsAws
  class ActsAsElbHttpListenerTest < ActiveSupport::TestCase
    test 'acts_as_elb_http_listener' do
      load_balancer = LoadBalancer.create!(client: client, name: 'acts-as-aws-test-http')
      client.elb_client.wait_until(:load_balancer_exists, load_balancer_arns: [load_balancer.aws_load_balancer_arn])

      attrs = { load_balancer: load_balancer }
      object1 = HttpListener.new(attrs)
      assert !object1.elb_http_listener_present?
      object1.save!

      assert_equal ActsAsAws::CREATED_STATUS, object1.elb_http_listener_status, object1.elb_http_listener_error
      assert object1.elb_http_listener_arn.present?

      assert object1.elb_http_listener_present?
      object1.destroy!

      object2 = HttpListener.create!(attrs.merge(elb_http_listener_arn: object1.elb_http_listener_arn, elb_http_listener_status: ActsAsAws::CREATED_STATUS))
      assert !object2.elb_http_listener_present?
      assert_equal ActsAsAws::MISSING_STATUS, object2.elb_http_listener_status, object2.elb_http_listener_error
    end
  end
end
