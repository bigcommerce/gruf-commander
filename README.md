# Gruf Commander

Assists with request/command-style syntax and validation in gruf requests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gruf-commander'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gruf-commander

## Usage

Gruf Commander supports the Command/Request design pattern. You create Request classes that perform validation,
and then submit themselves to a Command. The Command class then performs the business logic by interacting
with internal layers of the application, such as the service, DTO, or repository layers.

First, in your gruf initializer, add the interceptor:

```ruby
Gruf.configure do |c|
  c.interceptors.use(Gruf::Commander::RequestValidationInterceptor)
end
```

Then you'll create your command and request classes:

```ruby
class CreateBoxCommand < Gruf::Commander::Command
  def call(request)
    Box.create!(width: request.width, height: request.height)
  end
end


class CreateBoxRequest < Gruf::Commander::Request
  attr_reader :width
  attr_reader :height
  
  validate :validate_width, :validate_height
  
  def initialize(width:, height:)
    @width = width
    @height = height
    super(command: CreateBoxCommand.new)
  end
  
  private
  
  def validate_width
    return if @width.to_i > 0    
    errors.add(:width, :invalid_width, message: 'Please enter a valid width!')
  end
  
  def validate_height
    return if @height.to_i > 0    
    errors.add(:height, :invalid_height, message: 'Please enter a valid height!')
  end
end
```

Then, in your gruf controller:

```ruby
def create_box
  request = CreateBoxRequest.new(
    width: request.message.width.to_i,
    height: request.message.height.to_i,
  )
  box = request.submit!
  Rpc::CreateBoxResponse.new(
    box: Rpc::Box.new(height: box.height, width: box.width)
  )
end
```

Gruf Commander will automatically handle the validation errors to push back to the grpc server, properly sending an
`GRPC::InvalidArgument` exception should validation fail.

### Configuration

You can configure the request validation options:

|Config Name|Description|Default|
|---|---|---|
|`invalid_request_error_code`|Sets the gRPC error code sent back on failed validation.|`:invalid_argument`|
|`invalid_request_app_error_code`|Sets the app error code sent back on failed validation.|`:invalid_request`|
|`invalid_request_message`|Sets the error message sent back on failed validation.|Invalid Request|

### Dependency Injection

Gruf Commander works very well with DI systems such as [dry-rb](http://dry-rb.org/), since Request objects can simply
just provide accessors to modify their attributes, and commands are simple plain classes that can have no strict 
contract on initialization.

We recommend using a DI system (such as dry-rb) to use with Gruf Commander, as it helps with testing and refactoring
in more complex applications. 

## License

Copyright (c) 2018-present, BigCommerce Pty. Ltd. All rights reserved 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
