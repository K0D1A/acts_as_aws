class Certificate < ApplicationRecord
  belongs_to :client
  delegate :acm_client, to: :client

  acts_as_acm_certificate
end
