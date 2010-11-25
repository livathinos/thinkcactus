class Hash

  def compact
    delete_if { |key, value| value.blank? }
  end

end
