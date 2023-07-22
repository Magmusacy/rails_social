class AddDefaultFalseToConfirmedInvitation < ActiveRecord::Migration[7.0]
  def change
    change_column_default :invitations, :confirmed, from: nil, to: false
  end
end
