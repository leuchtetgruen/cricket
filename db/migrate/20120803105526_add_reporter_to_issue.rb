class AddReporterToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :reporter_name, :string
    add_column :issues, :reporter_email, :string
  end
end
