class ActiveRecord::Base

  #--
  #     >> Post.to_resource
  #     => "posts"
  #     >> Admin::User.to_resource
  #     => "admin/users"
  #++
  def self.to_resource
    name.underscore.pluralize
  end

  #--
  # TODO: This has been copied from Rails 2 because has been removed from
  #       Rails 3. Once the "build_conditions" has been refactored to use Arel
  #       this can be removed.
  #++
  def self.merge_conditions(*conditions)
    segments = []

    conditions.each do |condition|
      unless condition.blank?
        sql = sanitize_sql(condition)
        segments << sql unless sql.blank?
      end
    end

    "(#{segments.join(') AND (')})" unless segments.empty?
  end

  #--
  # On a model:
  #
  #     class Post < ActiveRecord::Base
  #       STATUS = {  t("Published") => "published",
  #                   t("Pending") => "pending",
  #                   t("Draft") => "draft" }
  #     end
  #
  #     >> Post.first.status
  #     => "published"
  #     >> Post.first.mapping(:status)
  #     => "Published"
  #     >> I18n.locale = :es
  #     => :es
  #     >> Post.first.mapping(:status)
  #     => "Publicado"
  #++
  def mapping(attribute)
    values = self.class::const_get(attribute.to_s.upcase)

    if values.kind_of?(Array)
      case values.first
      when Array
        array_keys, array_values = values.transpose
      else
        array_keys = array_values = values
      end
      values = array_keys.to_hash_with(array_values)
    end

    values.invert[send(attribute)]
  end

  def to_label
    respond_to?(:name) ? send(:name) : [ self.class, id ].join("#")
  end

end
