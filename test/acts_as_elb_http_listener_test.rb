require 'test_helper'

module ActsAsAws
  class ActsAsElbHttpListenerTest < ActiveSupport::TestCase
    test 'acts_as_elb_http_listener' do
      attrs = { load_balancer: @load_balancer }
      create_obj = HttpListener.new(attrs)
      assert !create_obj.elb_http_listener_present?
      create_obj.save!

      assert_equal ActsAsAws::PRESENT_STATUS, create_obj.elb_http_listener_status, create_obj.elb_http_listener_error
      assert create_obj.elb_http_listener_arn.present?
      assert create_obj.elb_http_listener_present?

      attrs[:elb_http_listener_arn] = create_obj.elb_http_listener_arn
      present_obj = HttpListener.create!(attrs)
      assert_equal ActsAsAws::PRESENT_STATUS, present_obj.elb_http_listener_status

      create_obj.destroy!
      present_obj.destroy!

      missing_obj = HttpListener.create!(attrs)
      assert !missing_obj.elb_http_listener_present?
      assert_equal ActsAsAws::MISSING_STATUS, missing_obj.elb_http_listener_status, missing_obj.elb_http_listener_error
      missing_obj.destroy!
    end

    private

    def setup
      @load_balancer = LoadBalancer.create!(client: client, name: 'acts-as-aws-test-https')
      client.elb_client.wait_until(:load_balancer_exists, load_balancer_arns: [@load_balancer.aws_load_balancer_arn])
    end

    def teardown
      @load_balancer.destroy!
    end
  end
end
