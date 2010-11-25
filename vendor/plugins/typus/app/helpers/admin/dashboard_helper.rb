module Admin

  module DashboardHelper

    def applications
      render File.join(path, "applications")
    end

    def resources(current_user)
      available = Typus.resources.map do |resource|
                    resource if current_user.resources.include?(resource)
                  end.compact
      render File.join(path, "resources"), :resources => available
    end

    private

    def path
      "admin/helpers/dashboard"
    end

  end

end
