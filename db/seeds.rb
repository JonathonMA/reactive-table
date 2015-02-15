require 'csv'
games = CSV.table Rails.root.join("db", "games.csv")
puts "----> Loading games (#{games.size})"
games.each_slice(100).with_index do |slice, i|
  Game.transaction do
    slice.each do |game|
      hash = game.to_h.slice(:title, :developer, :publisher, :released_on)
      Game.create! hash
    end
  end
  puts "      #{i * 100 + slice.size} loaded..."
end
