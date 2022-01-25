class CreateHttpsListeners < ActiveRecord::Migration[6.1]
  def change
    create_table :https_listeners do |t|
      t.references :load_balancer, null: false, foreign_key: true
      t.references :certificate, null: false, foreign_key: true
      t.string :elb_ssl_policy
      t.string :elb_https_listener_arn
      t.string :elb_https_listener_status
      t.string :elb_https_listener_error

      t.timestamps
    end
  end
end
