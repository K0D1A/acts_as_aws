require 'test_helper'

module ActsAsAws
  class ActsAsElbTargetGRoupTest < ActiveSupport::TestCase
    test 'acts_as_elb_target_group' do
      attrs = {
        client: client,
        elb_target_group_name: 'tg-test',
      }
      create_obj = TargetGroup.new(attrs)
      assert !create_obj.elb_target_group_present?
      create_obj.save!

      assert_equal ActsAsAws::PRESENT_STATUS, create_obj.elb_target_group_status, create_obj.elb_target_group_error
      assert create_obj.elb_target_group_arn.present?
      sleep 1
      assert create_obj.elb_target_group_present?

      attrs[:elb_target_group_arn] = create_obj.elb_target_group_arn
      present_obj = TargetGroup.create!(attrs)
      assert_equal ActsAsAws::PRESENT_STATUS, present_obj.elb_target_group_status

      create_obj.destroy!
      present_obj.destroy!

      missing_obj = TargetGroup.create!(attrs)
      assert !missing_obj.elb_target_group_present?
      assert_equal ActsAsAws::MISSING_STATUS, missing_obj.elb_target_group_status
    end
  end
end
