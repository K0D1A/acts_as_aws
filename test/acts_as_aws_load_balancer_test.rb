require 'test_helper'

module ActsAsAws
  class ActsAsAwsLoadBalancerTest < ActiveSupport::TestCase
    test 'acts_as_aws_load_balancer' do
      attrs = {
        client: client,
        name: 'acts-as-aws-test',
      }
      create_obj = LoadBalancer.new(attrs)
      assert !create_obj.aws_load_balancer_present?
      create_obj.save!

      assert_equal ActsAsAws::PRESENT_STATUS, create_obj.aws_load_balancer_status, create_obj.aws_load_balancer_error
      assert create_obj.aws_load_balancer_arn.present?
      assert create_obj.hostname.present?

      client.elb_client.wait_until(:load_balancer_exists, load_balancer_arns: [create_obj.aws_load_balancer_arn])
      assert create_obj.aws_load_balancer_present?

      attrs[:aws_load_balancer_arn] = create_obj.aws_load_balancer_arn
      present_obj = LoadBalancer.create!(attrs)
      assert_equal ActsAsAws::PRESENT_STATUS, present_obj.aws_load_balancer_status

      create_obj.destroy!
      client.elb_client.wait_until(:load_balancers_deleted, load_balancer_arns: [create_obj.aws_load_balancer_arn])
      present_obj.destroy!

      missing_obj = LoadBalancer.create!(attrs)
      assert !missing_obj.aws_load_balancer_present?
      assert_equal ActsAsAws::MISSING_STATUS, missing_obj.aws_load_balancer_status, missing_obj.aws_load_balancer_error
    end
  end
end
