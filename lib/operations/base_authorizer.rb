# Authorizer class suppose to check if associated operation with defined
# @params is allowed for @current_user. Call method should return an array
# of errors if something prevents the operation, or blank value otherwise.
#
# NOTE: In case it will be necessary to implement i18n here (to get
# human-redable version of authorization error messages), it could
# be implemented like so:
#
# failed_checks.map { |check| [prefix, check].join('.') }
#
# def prefix
#   @prefix ||= self.class.name.underscore.gsub('/', '.')
# end
#
# Assuming there will be a JSON on client side with translated messages.
#
# TODO: Refactor base class with Callee
module Operations
  class BaseAuthorizer < CheckSequenceRunner
    extend Dry::Initializer

    option :user, optional: true, default: -> { nil }
    option :params, optional: true, default: proc { {} }

    def self.call(options = {})
      new(**options).call
    end
  end
end
