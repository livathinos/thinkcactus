class String

  def extract_settings
    split(",").map { |x| x.strip }
  end

  def remove_prefix(prefix = 'admin/')
    partition(prefix).last
  end

  def extract_class
    remove_prefix.classify.typus_constantize
  end

  def typus_constantize
    Typus::Configuration.models_constantized[self]
  end

end
