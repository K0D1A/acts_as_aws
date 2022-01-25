require 'test_helper'

module ActsAsAws
  class ActsAsElbHttpsListenerTest < ActiveSupport::TestCase
    test 'acts_as_elb_https_listener' do
      attrs = {
        load_balancer: @load_balancer,
        certificate: @certificate,
        elb_ssl_policy: 'ELBSecurityPolicy-2015-05',
      }
      object1 = HttpsListener.new(attrs)
      assert !object1.elb_https_listener_present?
      object1.save!

      assert_equal ActsAsAws::CREATED_STATUS, object1.elb_https_listener_status, object1.elb_https_listener_error
      assert object1.elb_https_listener_arn.present?

      assert object1.elb_https_listener_present?
      object1.destroy!

      object2 = HttpsListener.create!(attrs.merge(elb_https_listener_arn: object1.elb_https_listener_arn, elb_https_listener_status: ActsAsAws::CREATED_STATUS))
      assert !object2.elb_https_listener_present?
      assert_equal ActsAsAws::MISSING_STATUS, object2.elb_https_listener_status, object2.elb_https_listener_error
      object2.destroy!
    end

    private

    def setup
      @load_balancer = LoadBalancer.create!(client: client, name: 'acts-as-aws-test-https')
      client.elb_client.wait_until(:load_balancer_exists, load_balancer_arns: [@load_balancer.aws_load_balancer_arn])

      @certificate = Certificate.create!(
        client: client,
        certificate: File.read(ENV.fetch('ACTS_AS_AWS_TEST_ACM_CERTIFICATE_CERTIFICATE_FILE')),
        private_key: File.read(ENV.fetch('ACTS_AS_AWS_TEST_ACM_CERTIFICATE_PRIVATE_KEY_FILE')),
        ca_bundle: File.read(ENV.fetch('ACTS_AS_AWS_TEST_ACM_CERTIFICATE_CA_BUNDLE_FILE'))
      )
      sleep 1
    end

    def teardown
      @certificate.destroy!
      @load_balancer.destroy!
    end
  end
end
