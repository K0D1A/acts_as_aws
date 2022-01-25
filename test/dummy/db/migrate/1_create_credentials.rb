class CreateCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :credentials do |t|
      t.string :aws_access_key
      t.string :aws_secret_key

      t.timestamps
    end
  end
end
