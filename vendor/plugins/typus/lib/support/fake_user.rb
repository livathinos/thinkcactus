class FakeUser

  def id
    0
  end

  def can?(*args)
    true
  end

  def cannot?(*args)
    !can?(*args)
  end

  def is_root?
    true
  end

  def is_not_root?
    !is_root?
  end

  def preferences
    { :locale => Typus.available_locales.first }
  end

  def resources
    Typus::Configuration.roles[role].compact
  end

  def applications
    Typus.applications
  end

  def application(name)
    Typus.application(name)
  end

  def role
    Typus.master_role
  end

  def name
  end

end
