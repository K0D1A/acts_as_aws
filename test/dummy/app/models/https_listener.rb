class HttpsListener < ApplicationRecord
  belongs_to :load_balancer
  delegate :elb_client, :aws_load_balancer_arn, to: :load_balancer

  belongs_to :certificate
  delegate :acm_certificate_arn, to: :certificate

  acts_as_elb_https_listener
end
