ActiveAdmin.register Post do
  controller do
    def permitted_params
      params.permit!
    end
  end
end
