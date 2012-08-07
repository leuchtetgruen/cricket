class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :issue
      t.references :user
      t.text :text

      t.timestamps
    end
  end
end
