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
require 'spec_helper'

describe Gruf::Commander::RequestValidationInterceptor do
  let(:controller_request) { double(:controller_request) }

  let(:controller_request) do
    double(
      :controller_request,
      method_key: 'create_box',
      service: Rpc::BoxService,
      rpc_desc: nil,
      active_call: grpc_active_call,
      message: Rpc::CreateBoxRequest
    )
  end
  let(:error) { Gruf::Error.new }
  let(:options) { {} }
  let(:interceptor) { described_class.new(controller_request, error, options) }

  let(:request) { CreateBoxRequest.new(width: 5, height: 10) }

  describe '.call' do
    subject { interceptor.call { request.submit! } }

    context 'when the call succeeds' do
      it 'should noop' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when the call raises an InvalidRequest' do
      let(:request) { CreateBoxRequest.new(width: 0, height: 10) }

      it 'should fail and set the appropriate field errors' do
        expect { subject }.to raise_error(GRPC::InvalidArgument) do |e|
          expect(e.details).to eq 'Invalid request'
          expect(e.code).to eq 3

          err = JSON.parse(e.metadata[:'error-internal-bin'])
          expect(err['code']).to eq 'invalid_argument'
          expect(err['app_code']).to eq 'invalid_request'
          expect(err['message']).to eq 'Invalid request'

          expect(err['field_errors']).to_not be_empty
          fe = err['field_errors'][0]
          expect(fe['field_name']).to eq 'width'
          expect(fe['error_code']).to eq 'invalid_width'
          expect(fe['message']).to eq 'Please enter a valid width!'
        end
      end
    end
  end
end
