class LoadBalancer < ApplicationRecord
  belongs_to :client
  delegate :elb_client, to: :client

  acts_as_aws_load_balancer

  def aws_load_balancer_subnet_ids
    ENV.fetch('ACTS_AS_AWS_TEST_AWS_LOAD_BALANCER_SUBNETS').split(',')
  end

  def aws_load_balancer_security_group_ids
    ENV.fetch('ACTS_AS_AWS_TEST_AWS_LOAD_BALANCER_SECURITY_GROUPS').split(',')
  end
end
