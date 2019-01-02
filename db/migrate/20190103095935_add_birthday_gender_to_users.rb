class AddBirthdayGenderToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :gender, :integer
  end
end
