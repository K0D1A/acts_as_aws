class CreateCertificates < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.references :client, null: false, foreign_key: true
      t.string :acm_certificate_arn
      t.string :acm_certificate_status
      t.string :acm_certificate_error
      t.string :certificate
      t.string :private_key
      t.string :ca_bundle

      t.timestamps
    end
  end
end
