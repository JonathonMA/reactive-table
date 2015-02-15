class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.string :developer
      t.string :publisher
      t.date :released_on

      t.timestamps null: false
    end
  end
end
