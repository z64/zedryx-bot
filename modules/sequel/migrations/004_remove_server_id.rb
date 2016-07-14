Sequel.migration do

  up do
    alter_table(:users) do
      drop_column(:server_id)
    end
  end

  down do
    alter_table(:users) do
      add_column(:server_id, Integer)
    end
  end

end
