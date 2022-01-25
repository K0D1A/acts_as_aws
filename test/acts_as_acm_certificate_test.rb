require 'test_helper'

module ActsAsAws
  class ActsAsAcmCertificateTest < ActiveSupport::TestCase
    test 'acts_as_acm_certificate' do
      attrs = {
        client: client,
        certificate: File.read(ENV.fetch('ACTS_AS_AWS_TEST_ACM_CERTIFICATE_CERTIFICATE_FILE')),
        private_key: File.read(ENV.fetch('ACTS_AS_AWS_TEST_ACM_CERTIFICATE_PRIVATE_KEY_FILE')),
        ca_bundle: File.read(ENV.fetch('ACTS_AS_AWS_TEST_ACM_CERTIFICATE_CA_BUNDLE_FILE'))
      }
      object1 = Certificate.new(attrs)
      assert !object1.acm_certificate_present?
      object1.save!

      assert_equal ActsAsAws::CREATED_STATUS, object1.acm_certificate_status, object1.acm_certificate_error
      assert object1.acm_certificate_arn.present?

      sleep 1
      assert object1.acm_certificate_present?
      object1.destroy!

      object2 = Certificate.create!(attrs.merge(acm_certificate_arn: object1.acm_certificate_arn, acm_certificate_status: ActsAsAws::CREATED_STATUS))
      assert !object2.acm_certificate_present?
      assert_equal ActsAsAws::MISSING_STATUS, object2.acm_certificate_status, object2.acm_certificate_error
    end
  end
end
