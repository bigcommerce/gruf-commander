# frozen_string_literal: true

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
    # Used when submitting requests from commands; utilize to issue a validation exception on a request
    #
    class InvalidRequest < StandardError
      attr_reader :request

      ##
      # @param [Request] request
      # @param [String] message
      #
      def initialize(request, message = '')
        @request = request
        super(message)
      end
    end

    ##
    # Base request class
    #
    class Request
      include ActiveModel::Validations

      # @var [Command] command
      attr_reader :command

      ##
      # @param [Command] command
      #
      def initialize(command:)
        @command = command
      end

      ##
      # Validate and submit the request
      #
      # @raise [InvalidRequest] if the request is invalid
      # rubocop:disable Style/RaiseArgs
      def submit!
        raise InvalidRequest.new(self) unless valid?

        command.call(self)
      end
      # rubocop:enable Style/RaiseArgs
    end
  end
end
