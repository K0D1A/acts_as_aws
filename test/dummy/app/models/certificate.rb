class Certificate < ApplicationRecord
  belongs_to :client
  delegate :acm_client, to: :client

  acts_as_acm_certificate

  def acm_certificate_tags
    { 'Name' => 'acts_as_aws_test' }
  end
end
