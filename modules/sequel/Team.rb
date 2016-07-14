module Zedryx
  class Team < Sequel::Model(:teams)
    one_to_many :users
  end
end
