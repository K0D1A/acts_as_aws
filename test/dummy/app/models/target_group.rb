class TargetGroup < ApplicationRecord
  belongs_to :client
  delegate :elb_client, to: :client

  acts_as_elb_target_group

  def aws_vpc_id
    ENV.fetch('ACTS_AS_AWS_TEST_ELB_TARGET_GROUP_VPC_ID')
  end
end
