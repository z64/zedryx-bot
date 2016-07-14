module Zedryx
  class Chatlog < Sequel::Model(:chatlogs)
    def before_create
      super
      self.timestamp ||= Time.now
    end
  end
end
