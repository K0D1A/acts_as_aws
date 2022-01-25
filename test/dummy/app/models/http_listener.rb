class HttpListener < ApplicationRecord
  belongs_to :load_balancer
  delegate :elb_client, :aws_load_balancer_arn, to: :load_balancer

  acts_as_elb_http_listener
end
