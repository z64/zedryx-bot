Sequel.migration do

  up do
    add_column :chatlogs, :message_content, String
  end

  down do
    drop_column :chatlogs, :message_content
  end

end