class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description
      t.integer :type
      t.references :user
      t.references :software

      t.timestamps
    end
  end
end
