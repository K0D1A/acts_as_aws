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
      create_obj = Certificate.new(attrs)
      assert !create_obj.acm_certificate_present?
      create_obj.save!

      assert_equal ActsAsAws::PRESENT_STATUS, create_obj.acm_certificate_status, create_obj.acm_certificate_error
      assert create_obj.acm_certificate_arn.present?
      sleep 1
      assert create_obj.acm_certificate_present?

      attrs[:acm_certificate_arn] = create_obj.acm_certificate_arn
      present_obj = Certificate.create!(attrs)
      assert_equal ActsAsAws::PRESENT_STATUS, present_obj.acm_certificate_status

      create_obj.destroy!
      present_obj.destroy!

      missing_obj = Certificate.create!(attrs)
      assert !missing_obj.acm_certificate_present?
      assert_equal ActsAsAws::MISSING_STATUS, missing_obj.acm_certificate_status
    end
  end
end
