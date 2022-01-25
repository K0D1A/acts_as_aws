class Client < ApplicationRecord
  belongs_to :credentials
  delegate :aws_credentials, to: :credentials

  acts_as_acm_client
  acts_as_ec2_client
  acts_as_elb_client
  acts_as_rds_client
end
