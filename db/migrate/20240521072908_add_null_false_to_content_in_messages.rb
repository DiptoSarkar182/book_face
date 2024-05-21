class AddNullFalseToContentInMessages < ActiveRecord::Migration[7.1]
  def change
    change_column_null :messages, :content, false
  end
end
