class AddNullFalseToBodyInComments < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comments, :body, false
  end
end
