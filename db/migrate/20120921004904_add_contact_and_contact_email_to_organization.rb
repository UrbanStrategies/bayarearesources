class AddContactAndContactEmailToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :contact, :string
  end
end
