class CreateLoadBalancers < ActiveRecord::Migration[6.1]
  def change
    create_table :load_balancers do |t|
      t.references :client, null: false, foreign_key: true
      t.string :aws_load_balancer_arn
      t.string :aws_load_balancer_status
      t.string :aws_load_balancer_error
      t.string :name
      t.string :hostname

      t.timestamps
    end
  end
end
