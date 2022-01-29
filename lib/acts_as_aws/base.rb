module ActsAsAws
  CREATED_STATUS = 'created'
  DELETED_STATUS = 'deleted'
  MISSING_STATUS = 'missing'
  CREATION_ERROR_STATUS = 'creation_error'
  DELETION_ERROR_STATUS = 'deletion_error'
  PRESENCE_ERROR_STATUS = 'presence_error'

  module Base
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_aws(**options)
        client_method = options[:client_method] or raise 'missing client_method'
        object_type = options[:object_type] or raise 'missing object_type'
        create_method = options[:create_method] || :"create_#{object_type}!"
        delete_method = options[:delete_method] || :"delete_#{object_type}!"
        presence_method = options[:presence_method] || :"#{object_type}_present?"
        status_attr = options[:status_attr] || :"#{object_type}_status"
        error_attr = options[:error_attr] || :"#{object_type}_error"
        identifier_attr = options[:identifier_attr] or raise 'missing identifier_attr'
        creation_params_proc = options[:creation_params_proc] or raise 'missing creation_params_proc'
        creation_proc = options[:creation_proc] or raise 'missing creation_proc'
        deletion_proc = options[:deletion_proc] or raise 'missing deletion_proc'
        presence_proc = options[:presence_proc] or raise 'missing presence_proc'
        missing_error_class = options[:missing_error_class]&.constantize

        define_method create_method do
          begin
            params = creation_params_proc.call self
            logger.debug "creating #{object_type} with params: #{params.inspect}"

            client = send(client_method)
            attrs = creation_proc.call client, params
            logger.info "created #{object_type} #{attrs.inspect}"
            update_columns attrs.merge(status_attr => CREATED_STATUS)
          rescue StandardError => e
            logger.error e
            update_columns(status_attr => CREATION_ERROR_STATUS, error_attr => [e.class.name, e.message].join(': '))
          end
        end

        define_method delete_method do
          begin
            return unless send(presence_method)

            identifier = send(identifier_attr)
            return if identifier.blank?
            logger.debug "deleting #{object_type} #{identifier}"

            client = send(client_method)
            deletion_proc.call client, identifier
            logger.info "deleted #{object_type} #{identifier}"
            update_columns(status_attr => DELETED_STATUS)
          rescue StandardError => e
            logger.error e
            update_columns(status_attr => DELETION_ERROR_STATUS, error_attr => [e.class.name, e.message].join(': '))
          end
        end

        define_method presence_method do
          begin
            status = send(status_attr)
            return false unless status.to_s == CREATED_STATUS

            identifier = send(identifier_attr)
            return false if identifier.blank?

            client = send(client_method)
            if presence_proc.call(client, identifier)
              logger.debug "found #{object_type} #{identifier}"
              return true
            else
              logger.info "missing #{object_type} #{identifier}"
              if persisted?
                update_columns(status_attr => MISSING_STATUS)
              else
                send :"#{status_attr}=", MISSING_STATUS
              end
            end
          rescue StandardError => e
            logger.error e

            status = missing_error_class && e.is_a?(missing_error_class) ? MISSING_STATUS : PRESENCE_ERROR_STATUS
            error = [e.class.name, e.message].join(': ')
            if persisted?
              update_columns(status_attr => status, error_attr => error)
            else
              send :"#{status_attr}=", status
              send :"#{error_attr}=", error
            end
          end

          false
        end

        after_create create_method, unless: identifier_attr
        before_destroy delete_method
      end
    end
  end
end
