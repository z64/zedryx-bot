Sequel.migration do

  up do
    create_table(:chatlogs) do
      primary_key :id
      DateTime    :timestamp
      Integer     :server_id
      String      :server_name
      Integer     :channel_id
      String      :channel_name
      Integer     :discord_id
      String      :user_name
    end
  end

  down do
    drop_table(:chatlog)
  end

end
