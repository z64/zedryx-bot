Sequel.migration do

  up do
    create_table(:users) do
      primary_key :id
      Integer     :discord_id, :unique => true, :null => false
      Integer     :server_id,  :null => false
      DateTime    :timestamp
      String      :name, :null => false
      foreign_key :team_id, :teams
    end

    create_table(:teams) do
      primary_key :id
      String      :name, :null => false
    end
  end

  down do
    drop_table(:users)
    drop_table(:teams)
  end

end
