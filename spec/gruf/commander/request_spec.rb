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
require 'spec_helper'

describe Gruf::Commander::Request do
  let(:request_params) { { width: 5, height: 10 } }
  let(:request) { CreateBoxRequest.new(**request_params) }

  describe '#submit!' do
    subject { request.submit! }

    context 'when the request is valid' do
      it 'runs call on the command' do
        expect(request.command).to receive(:call).with(request).once
        expect { subject }.not_to raise_error
      end
    end

    context 'when the request is invalid' do
      let(:request_params) { { width: 0, height: 7 } }

      it 'raises an InvalidRequest exception' do
        expect { subject }.to raise_error(Gruf::Commander::InvalidRequest)
      end
    end
  end
end
