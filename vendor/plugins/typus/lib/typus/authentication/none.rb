module Typus

  module Authentication

    module None

      protected

      include Base

      def authenticate
        @current_user = FakeUser.new
      end

    end

  end

end
