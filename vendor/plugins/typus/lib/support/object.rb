class Object

  ##
  # Instead of having to translate strings and defining a default value:
  #
  #     t("Hello World!", :default => 'Hello World!')
  #
  # We define this method to define the value only once:
  #
  #     _t("Hello World!")
  #
  # Note that interpolation still works ...
  #
  #     _t("Hello %{world}!", :world => @world)
  #
  def _t(msg, *args)
    options = args.extract_options!
    options[:default] = msg
    I18n.t(msg, options)
  end

end
