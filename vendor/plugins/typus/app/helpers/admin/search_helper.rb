module Admin

  module SearchHelper

    def search(resource = @resource)
      if (typus_search = resource.typus_defaults_for(:search)) && typus_search.any?
        search_params = params.dup
        %w(action controller id search page utf8).each { |p| search_params.delete(p) }
        options = { :hidden_params => search_params.map { |k, v| hidden_field_tag(k, v) } }
        render "admin/helpers/search/search", options
      end
    end

  end

end
