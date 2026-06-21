# frozen_string_literal: true

class AddMcpTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :mcp_token, :string
    add_index :users, :mcp_token, unique: true
  end
end
