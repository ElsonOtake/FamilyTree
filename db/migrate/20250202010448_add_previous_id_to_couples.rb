# O load da tabela utilizando o id não reindexa o índice primário
# Os comandos de reindexação de tabela ou índice não solucionam o problema
# Esse novo campo será utilizado como referência para criar os filhos
class AddPreviousIdToCouples < ActiveRecord::Migration[7.0]
  def change
    add_column :couples, :previous_id, :bigint
    add_index :couples, :previous_id
  end
end
