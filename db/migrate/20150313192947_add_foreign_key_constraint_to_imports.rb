class AddForeignKeyConstraintToImports < ActiveRecord::Migration
  change_table :imports do |t|
    t.foreign_key :users    
  end
end
