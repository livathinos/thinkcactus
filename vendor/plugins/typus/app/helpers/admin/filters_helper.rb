module Admin

  module FiltersHelper

    def build_filters(resource = @resource)
      typus_filters = resource.typus_filters

      return if typus_filters.empty?

      current_request = request.env['QUERY_STRING'] || []

      filters = typus_filters.map do |key, value|
        filter, items, message = case value
                                 when :boolean then boolean_filter(current_request, key)
                                 when :string then string_filter(current_request, key)
                                 when :date, :datetime then date_filter(current_request, key)
                                 when :belongs_to then relationship_filter(current_request, key)
                                 when :has_many, :has_and_belongs_to_many then
                                   relationship_filter(current_request, key, true)
                                 # when nil then
                                     # Do nothing. This is ugly but for now it's ok.
                                 else
                                   string_filter(current_request, key)
                                 end

        items = items.to_a
        items.insert(0, [message, ""])

        { :filter => filter, :items => items }
      end

      render "admin/helpers/filters/filters", :filters => filters
    end

    def relationship_filter(request, filter, habtm = false)
      att_assoc = @resource.reflect_on_association(filter.to_sym)
      class_name = att_assoc.options[:class_name] || ((habtm) ? filter.classify : filter.capitalize.camelize)
      model = class_name.typus_constantize
      related_fk = (habtm) ? filter : att_assoc.primary_key_name

      params_without_filter = params.dup
      %w(controller action page).each { |p| params_without_filter.delete(p) }
      params_without_filter.delete(related_fk)

      items = model.order(model.typus_order_by).map { |v| [v.to_label, v.id] }
      message = _t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize)

      [related_fk, items, message]
    end

    def date_filter(request, filter)
      values  = %w(today last_few_days last_7_days last_30_days)
      items   = values.map { |v| [_t(v.humanize), v] }
      message = _t("Show all dates")
      [filter, items, message]
    end

    def boolean_filter(request, filter)
      items   = @resource.typus_boolean(filter)
      message = _t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase)
      [filter, items, message]
    end

    def string_filter(request, filter)
      values  = @resource::const_get(filter.to_s.upcase)
      items   = values.kind_of?(Hash) ? values : values.to_hash_with(values)
      message = _t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase)
      [filter, items, message]
    end

    def remove_filter_link(filter = request.env['QUERY_STRING'], params = params)
      return unless filter.present?
      message = params.compact.include?(:search) ? "search" : "filter"
      link_to _t("Remove #{message}")
    end

  end

end
