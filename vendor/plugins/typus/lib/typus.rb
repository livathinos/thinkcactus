# coding: utf-8

require "support/active_record"
require "support/array"
require "support/hash"
require "support/object"
require "support/string"

require "typus/engine"
require "typus/orm/active_record"
require "typus/user"
require "typus/version"

require 'will_paginate'

autoload :FakeUser, "support/fake_user"

module Typus

  autoload :Configuration, "typus/configuration"
  autoload :Resources, "typus/resources"

  module Authentication
    autoload :Base, "typus/authentication/base"
    autoload :None, "typus/authentication/none"
    autoload :HttpBasic, "typus/authentication/http_basic"
    autoload :Session, "typus/authentication/session"
  end

  mattr_accessor :admin_title
  @@admin_title = "Typus"

  mattr_accessor :admin_sub_title
  @@admin_sub_title = <<-CODE
<a href="http://core.typuscms.com/">typus</a> by <a href="http://intraducibles.com">intraducibles.com</a>
  CODE

  ##
  # Available Authentication Mechanisms are:
  #
  # - none
  # - basic: Uses http authentication
  # - session
  #
  mattr_accessor :authentication
  @@authentication = :none

  mattr_accessor :config_folder
  @@config_folder = "config/typus"

  mattr_accessor :username
  @@username = "admin"

  ##
  # Pagination options
  #
  mattr_accessor :pagination
  @@pagination = { :previous_label => "&larr; " + _t("Previous"),
                   :next_label => _t("Next") + " &rarr;" }

  ##
  # Define a password.
  #
  # Used as default password for http and advanced authentication.
  #
  mattr_accessor :password
  @@password = "columbia"

  ##
  # Configure the e-mail address which will be shown in Admin::Mailer.
  #
  # When `nil`, the `forgot_password` will be disabled.
  #
  mattr_accessor :mailer_sender
  @@mailer_sender = nil

  mattr_accessor :file_preview
  @@file_preview = :medium

  mattr_accessor :file_thumbnail
  @@file_thumbnail = :thumb

  ##
  # Defines the default relationship table.
  #
  mattr_accessor :relationship
  @@relationship = "typus_users"

  mattr_accessor :master_role
  @@master_role = "admin"

  mattr_accessor :user_class_name
  @@user_class_name = "TypusUser"

  mattr_accessor :user_fk
  @@user_fk = "typus_user_id"

  mattr_accessor :available_locales
  @@available_locales = [:en]

  class << self

    # Default way to setup typus. Run `rails generate typus` to create a fresh
    # initializer with all configuration values.
    def setup
      yield self
    end

    def root
      (File.dirname(__FILE__) + "/../").chomp("/lib/../")
    end

    def applications
      Typus::Configuration.config.map { |i| i.last["application"] }.compact.uniq.sort
    end

    # Lists modules of an application.
    def application(name)
      Typus::Configuration.config.map { |i| i.first if i.last["application"] == name }.compact.uniq.sort
    end

    # Lists models from the configuration file.
    def models
      Typus::Configuration.config.map { |i| i.first }.sort
    end

    # Lists resources, which are tableless models.
    def resources
      Typus::Configuration.roles.keys.map do |key|
        Typus::Configuration.roles[key].keys
      end.flatten.sort.uniq.delete_if { |x| models.include?(x) }
    end

    # Lists models under <tt>app/models</tt>.
    def detect_application_models
      model_dir = Rails.root.join("app/models")
      Dir.chdir(model_dir) { Dir["**/*.rb"] }
    end

    def locales
      human = available_locales.map { |i| locales_mapping[i.to_s] }
      available_locales.map { |i| i.to_s }.to_hash_with(human).invert
    end

    def locales_mapping
      mapping = { "ca"    => "Català",
                  "de"    => "German",
                  "en"    => "English",
                  "es"    => "Español",
                  "fr"    => "Français",
                  "hu"    => "Magyar",
                  "it"    => "Italiano",
                  "pt-BR" => "Portuguese",
                  "ru"    => "Russian" }
      mapping.default = "Unknown"
      return mapping
    end

    def detect_locales
      available_locales.each do |locale|
        I18n.load_path += Dir[File.join(Typus.root, "config", "available_locales", "#{locale}*")]
      end
    end

    def application_models
      detect_application_models.map do |model|
        class_name = model.sub(/\.rb$/,"").camelize
        klass = class_name.split("::").inject(Object) { |klass,part| klass.const_get(part) }
        class_name if klass < ActiveRecord::Base && !klass.abstract_class?
      end.compact
    end

    def user_class
      user_class_name.typus_constantize
    end

    def reload!
      Typus::Configuration.roles!
      Typus::Configuration.config!
      detect_locales
    end

  end

end

Typus.reload!
