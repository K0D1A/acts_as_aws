class CreateHttpListeners < ActiveRecord::Migration[6.1]
  def change
    create_table :http_listeners do |t|
      t.references :load_balancer, null: false, foreign_key: true
      t.string :elb_http_listener_arn
      t.string :elb_http_listener_status
      t.string :elb_http_listener_error

      t.timestamps
    end
  end
end
