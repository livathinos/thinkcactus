module Admin

  module BaseHelper

    def typus_render(*args)
      options = args.extract_options!
      options[:resource] ||= @resource.to_resource

      template_file = Rails.root.join("app", "views", "admin", options[:resource], "_#{options[:partial]}.html.erb")
      resource = File.exists?(template_file) ? options[:resource] : "resources"

      render "admin/#{resource}/#{options[:partial]}", :options => options
    end

    def title(page_title)
      content_for(:title) { page_title }
    end

    def header
      render "admin/helpers/header"
    end

    def apps
      render "admin/helpers/apps"
    end

    def login_info
      return if current_user.is_a?(FakeUser)

      admin_edit_typus_user_path = { :controller => "/admin/#{Typus.user_class.to_resource}",
                                     :action => 'edit',
                                     :id => current_user.id }

      message = _t("Are you sure you want to sign out and end your session?")

      user_details = if current_user.can?('edit', Typus.user_class_name)
                       link_to current_user.name, admin_edit_typus_user_path
                     else
                       current_user.name
                     end

      render "admin/helpers/login_info", :message => message, :user_details => user_details
    end

    def display_flash_message(message = flash)
      return if message.empty?
      render "admin/helpers/flash_message", :flash_type => message.keys.first, :message => message
    end

  end

end