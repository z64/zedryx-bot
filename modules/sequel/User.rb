module Zedryx
  class User < Sequel::Model(:users)
    many_to_one :team
    def before_create
      super
      self.timestamp ||= Time.now
    end
  end
end
