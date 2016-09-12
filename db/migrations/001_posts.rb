Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id

      String :feed, null: false
      String :title
      String :link
      String :description
      DateTime :pub_date
      String :guid
      json :extra
      String :freefeed_post_id
      DateTime :created_at

      index :link
      index :feed
    end
  end
end
