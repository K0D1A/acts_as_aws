require 'test_helper'

module ActsAsAws
  class ActsAsAwsLoadBalancerTest < ActiveSupport::TestCase
    test 'acts_as_aws_load_balancer' do
      attrs = {
        client: client,
        name: 'elb-acts-as-aws-test',
      }
      object1 = LoadBalancer.new(attrs)
      assert !object1.aws_load_balancer_present?
      object1.save!
      assert_equal ActsAsAws::CREATED_STATUS, object1.aws_load_balancer_status, object1.aws_load_balancer_error
      assert object1.hostname
      sleep 1
      assert object1.aws_load_balancer_present?
      object1.destroy!

      object2 = LoadBalancer.create!(attrs.merge(aws_load_balancer_arn: object1.aws_load_balancer_arn, aws_load_balancer_status: ActsAsAws::CREATED_STATUS))
      assert !object2.aws_load_balancer_present?
      assert_equal ActsAsAws::MISSING_STATUS, object2.aws_load_balancer_status, object2.aws_load_balancer_error
    end
  end
end
