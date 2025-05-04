class AddResourceToEvents < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :events, :resource, polymorphic: true, index: { algorithm: :concurrently }
  end
end
