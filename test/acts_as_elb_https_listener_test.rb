require 'test_helper'

module ActsAsAws
  class ActsAsElbHttpsListenerTest < ActiveSupport::TestCase
    test 'acts_as_elb_https_listener' do
      attrs = {
        load_balancer: @load_balancer,
        certificate: @certificate,
        elb_ssl_policy: 'ELBSecurityPolicy-2015-05',
      }
      create_obj = HttpsListener.new(attrs)
      assert !create_obj.elb_https_listener_present?
      create_obj.save!

      assert_equal ActsAsAws::PRESENT_STATUS, create_obj.elb_https_listener_status, create_obj.elb_https_listener_error
      assert create_obj.elb_https_listener_arn.present?

      attrs[:elb_https_listener_arn] = create_obj.elb_https_listener_arn
      present_obj = HttpsListener.create!(attrs)
      assert_equal ActsAsAws::PRESENT_STATUS, present_obj.elb_https_listener_status

      create_obj.destroy!
      present_obj.destroy!

      missing_obj = HttpsListener.create!(attrs.merge(elb_https_listener_arn: create_obj.elb_https_listener_arn, elb_https_listener_status: ActsAsAws::PRESENT_STATUS))
      assert !missing_obj.elb_https_listener_present?
      assert_equal ActsAsAws::MISSING_STATUS, missing_obj.elb_https_listener_status, missing_obj.elb_https_listener_error
      missing_obj.destroy!
    end

    private

    def setup
      @load_balancer = LoadBalancer.create!(client: client, name: 'elb-test-https-listener')
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
