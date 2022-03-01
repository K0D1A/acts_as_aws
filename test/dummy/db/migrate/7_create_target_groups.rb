class CreateTargetGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :target_groups do |t|
      t.references :client, null: false, foreign_key: true
      t.string :elb_target_group_arn
      t.string :elb_target_group_name
      t.string :elb_target_group_status
      t.string :elb_target_group_error

      t.timestamps
    end
  end
end
