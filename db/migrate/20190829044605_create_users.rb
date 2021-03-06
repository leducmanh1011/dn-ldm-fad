class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.datetime :birthday
      t.integer :sex
      t.string :phone
      t.string :address
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
