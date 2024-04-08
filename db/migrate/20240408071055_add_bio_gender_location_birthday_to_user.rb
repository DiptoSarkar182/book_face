class AddBioGenderLocationBirthdayToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :bio, :text
    add_column :users, :gender, :string
    add_column :users, :location, :string
    add_column :users, :birthday, :date
  end
end
