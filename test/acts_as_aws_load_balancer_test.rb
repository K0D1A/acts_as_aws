require 'test_helper'

module ActsAsAws
  class ActsAsAwsLoadBalancerTest < ActiveSupport::TestCase
    test 'acts_as_aws_load_balancer' do
      attrs = {
        client: client,
        name: 'acts-as-aws-test',
      }
      object1 = LoadBalancer.new(attrs)
      assert !object1.aws_load_balancer_present?
      object1.save!

      assert_equal ActsAsAws::CREATED_STATUS, object1.aws_load_balancer_status, object1.aws_load_balancer_error
      assert object1.aws_load_balancer_arn.present?
      assert object1.hostname.present?

      client.elb_client.wait_until(:load_balancer_exists, load_balancer_arns: [object1.aws_load_balancer_arn])
      assert object1.aws_load_balancer_present?

      object1.destroy!
      client.elb_client.wait_until(:load_balancers_deleted, load_balancer_arns: [object1.aws_load_balancer_arn])

      object2 = LoadBalancer.create!(attrs.merge(aws_load_balancer_arn: object1.aws_load_balancer_arn, aws_load_balancer_status: ActsAsAws::CREATED_STATUS))
      assert !object2.aws_load_balancer_present?
      assert_equal ActsAsAws::MISSING_STATUS, object2.aws_load_balancer_status, object2.aws_load_balancer_error
    end
  end
end
