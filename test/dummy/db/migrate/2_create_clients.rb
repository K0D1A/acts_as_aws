class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.references :credentials, null: false, foreign_key: true
      t.string :aws_region

      t.timestamps
    end
  end
end
