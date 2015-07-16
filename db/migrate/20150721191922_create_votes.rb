class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :user_id
      t.integer :status
      t.references :votable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end