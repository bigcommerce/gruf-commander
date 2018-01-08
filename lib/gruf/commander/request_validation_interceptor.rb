# Copyright (c) 2018-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
module Gruf
  module Commander
    ##
    # Does request validation error handling
    #
    class RequestValidationInterceptor < ::Gruf::Interceptors::ServerInterceptor
      def call
        yield # this returns the protobuf message
      rescue Gruf::Commander::InvalidRequest => e
        e.request.errors.details.each do |attr, errs|
          errs.each_with_index do |err, idx|
            add_field_error(attr, err.values.first.to_sym, e.request.errors.messages[attr].fetch(idx, ''))
          end
        end
        fail!(
          options.fetch(:invalid_request_error_code, :invalid_argument),
          options.fetch(:invalid_request_app_error_code, :invalid_request),
          options.fetch(:invalid_request_message, 'Invalid request')
        )
      end
    end
  end
end
