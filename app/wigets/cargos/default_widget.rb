module Cargos
  class DefaultWidget
    attr_accessor :relation

    def initialize(org_id, group_by = nil)
      @relation = Cargo.org_by(org_id, group_by)
    end

    def self.call(*)
      raise("Can't call default widgets. Use descendant call")
    end
  end
end
