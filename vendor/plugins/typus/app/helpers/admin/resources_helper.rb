module Admin

  module ResourcesHelper

    include FiltersHelper
    include FormHelper
    include RelationshipsHelper
    include PreviewHelper
    include SearchHelper
    include SidebarHelper
    include TableHelper

    #--
    # If partial `list` exists we will use it. This partial will have available
    # the `@items` so we can do whatever we want there. Notice that pagination
    # is still available.
    #++
    def build_list(model, fields, items, resource = @resource.to_resource, link_options = {}, association = nil)
      render "admin/#{resource}/list", :items => items
    rescue ActionView::MissingTemplate
      build_table(model, fields, items, link_options, association)
    end

    def display_link_to_previous
      return unless params[:back_to]

      options = {}
      options[:resource_from] = @resource.model_name.human
      options[:resource_to] = params[:resource].typus_constantize.model_name.human if params[:resource]

      editing = %w( edit update ).include?(params[:action])
      message = case
                when params[:resource] && editing
                  "You're updating a %{resource_from} for %{resource_to}."
                when editing
                  "You're updating a %{resource_from}."
                when params[:resource]
                  "You're adding a new %{resource_from} to %{resource_to}."
                else
                  "You're adding a new %{resource_from}."
                end
      message = _t(message,
                  :resource_from => options[:resource_from],
                  :resource_to => options[:resource_to])

      render File.join(path, "display_link_to_previous"), :message => message
    end

    private

    def path
      "admin/helpers/resources"
    end

  end

end
