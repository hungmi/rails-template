class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :oauth_uid
      t.string :oauth_token
      t.string :reset_token, null: false
      t.string :confirmation_token, null: false
      t.datetime :confirmed_at
      t.integer :expires_at
      t.string :provider
      t.integer :role, default: 0, null: false

      t.timestamps
    end
  end
end