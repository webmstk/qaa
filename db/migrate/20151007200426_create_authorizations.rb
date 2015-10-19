class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid
      t.boolean :confirmed, default: false

      t.timestamps null: false
    end
  end
end
