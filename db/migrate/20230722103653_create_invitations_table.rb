class CreateInvitationsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users } 
      t.boolean :confirmed

      t.timestamps
    end
  end
end
