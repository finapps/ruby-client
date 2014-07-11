module FinApps
  module REST

    class Accounts < FinApps::REST::Resources

    end

    class Account < FinApps::REST::Resource
      attr_accessor :public_id
    end

  end
end