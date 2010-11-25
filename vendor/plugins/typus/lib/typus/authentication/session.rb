module Typus

  module Authentication

    module Session

      protected

      include Base

      def authenticate
        if session[:typus_user_id]
          current_user
        else
          back_to = request.env['PATH_INFO'] unless [admin_dashboard_path, admin_path].include?(request.env['PATH_INFO'])
          redirect_to new_admin_session_path(:back_to => back_to)
        end
      end

      #--
      # Return the current user. If role does not longer exist on the
      # system current_user will be signed out from Typus.
      #++
      def current_user
        @current_user ||= Typus.user_class.find(session[:typus_user_id])

        if !Typus::Configuration.roles.has_key?(@current_user.role) || !@current_user.status
          session[:typus_user_id] = nil
          redirect_to new_admin_session_path
        end

        @current_user
      end

      #--
      # Action is available on: edit, update, toggle and destroy
      #++
      def check_if_user_can_perform_action_on_user
        return unless @item.kind_of?(Typus.user_class)

        message = case params[:action]
                  when 'edit'
                    # Only admin and owner of Typus User can edit.
                    if current_user.is_not_root? && (current_user != @item)
                      _t("As you're not the admin or the owner of this record you cannot edit it.")
                    end
                  when 'update'
                    # current_user cannot change her role.
                    if current_user.is_not_root? && !(@item.role == params[@object_name][:role])
                      _t("You can't change your role.")
                    end
                  when 'toggle'
                    # Only admin can toggle typus user status, but not herself.
                    if current_user.is_root? && (current_user == @item)
                      _t("You can't toggle your status.")
                    elsif current_user.is_not_root?
                      _t("You're not allowed to toggle status.")
                    end
                  when 'destroy'
                    # Admin can remove anything except herself.
                    if current_user.is_root? && (current_user == @item)
                      _t("You can't remove yourself.")
                    elsif current_user.is_not_root?
                      _t("You're not allowed to remove Typus Users.")
                    end
                  end

        redirect_to set_path, :notice => message if message
      end

      #--
      # This method checks if the user can perform the requested action.
      # It works on models, so its available on the `resources_controller`.
      #++
      def check_if_user_can_perform_action_on_resources
        unless current_user.can?(params[:action], @resource)
          message = _t("%{current_user_role} is not able to perform this action. (%{action})",
                       :current_user_role => current_user.role.capitalize,
                       :action => params[:action])

          redirect_to set_path, :notice => message
        end
      end

      #--
      # This method checks if the user can perform the requested action.
      # It works on a resource: git, memcached, syslog ...
      #++
      def check_if_user_can_perform_action_on_resource
        controller = params[:controller].remove_prefix
        unless current_user.can?(params[:action], controller.camelize, { :special => true })
          render :text => "Not allowed!", :status => :unprocessable_entity
        end
      end

      #--
      # If item is owned by another user, we only can perform a
      # show action on the item. Updated item is also blocked.
      #
      #   before_filter :check_resource_ownership, :only => [ :edit, :update, :destroy,
      #                                                       :toggle, :position,
      #                                                       :relate, :unrelate ]
      #++
      def check_resource_ownership
        return if current_user.is_root?

        condition_typus_users = @item.respond_to?(Typus.relationship) && !@item.send(Typus.relationship).include?(current_user)
        condition_typus_user_id = @item.respond_to?(Typus.user_fk) && !@item.owned_by?(current_user)

        if condition_typus_users || condition_typus_user_id
           alert = _t("You don't have permission to access this item.")
           redirect_to set_path, :alert => alert
        end
      end

      #--
      # Show only related items it @resource has a foreign_key (Typus.user_fk)
      # related to the logged user.
      #++
      def check_resource_ownerships
        return if current_user.is_root?

        if @resource.typus_user_id?
          condition = { Typus.user_fk => current_user }
          @conditions = @resource.merge_conditions(@conditions, condition)
        end
      end

      def check_ownership_of_referal_item
        return unless params[:resource] && params[:resource_id]
        klass = params[:resource].typus_constantize
        return if !klass.typus_user_id?
        item = klass.find(params[:resource_id])
        raise "You're not owner of this record." unless item.owned_by?(current_user) || current_user.is_root?
      end

      def set_attributes_on_create
        if @resource.typus_user_id?
          @item.attributes = { Typus.user_fk => current_user.id }
        end
      end

      def set_attributes_on_update
        if @resource.typus_user_id? && current_user.is_not_root?
          @item.update_attributes(Typus.user_fk => current_user.id)
        end
      end

      #--
      # Reload current_user when updating to see flash message in the
      # correct locale.
      #++
      def reload_locales
        if @resource.eql?(Typus.user_class)
          I18n.locale = current_user.reload.preferences[:locale]
        end
      end

    end

  end

end
