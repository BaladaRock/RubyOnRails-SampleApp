class AddResetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_digest, :stringreset_sent_at
  end
end
