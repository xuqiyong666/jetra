# 介绍

jetra是一个用于编写接口的微型框架，参考了sinatra的内部逻辑。sinatra封装了rack，所以只能用于写http接口。jetra可以理解为移除了rack层的sinatra。

## 代码示例

首先写一个基本的接口类

```ruby

require "jetra"

class ApiInterface < Jetra::Base

  route :greeting do
    "hello, world!"
  end

  route :repeat do
    "you said `#{params[:msg] || "nothing"}`"
  end

end
```

然后就可以这样调用

```ruby

ApiInterface.call(:greeting) 
#=> #<Jetra::Response:0x007fe1b68a5af8 @status=0, @body="hello, world!">

ApiInterface.call(:repeat, msg: "I am fine") 
#=> #<Jetra::Response:0x007fc1a8897be8 @status=0, @body="you said `I am fine`">

ApiInterface.call(:repeat) 
#=> #<Jetra::Response:0x007f804b07f8a0 @status=0, @body="you said `nothing`">
```

使用to_app，让方法调用更舒服

```ruby

App = ApiInterface.to_app

App.greeting 
#=> #<Jetra::Response:0x007fa4b4093868 @status=0, @body="hello, world!">

App.repeat(msg: "I am great") 
#=> #<Jetra::Response:0x007fed3508ec90 @status=0, @body="you said `I am great`">

App.repeat 
#=> #<Jetra::Response:0x007fd92f88dc08 @status=0, @body="you said `nothing`">
```

以上示例是程序内部调用，那么怎样才能支持接口的远程调用？

1. 转化为http接口

```ruby

require "rack"
require "jetra/adapter/rack"
RackApp = Jetra::RackAdapter.new(ApiInterface)

Rack::Server.start(
  app: RackApp, :Port => 9292
)
```

然后你就可以访问网址 http://localhost:9292/repeat?msg=work

2. 转化为thrift接口

server端代码
```ruby

  require "jetra"
  require "jetra/adapter/thrift"

  thriftApp = Jetra::ThriftAdapter.new(ApiInterface)

  port = 9090
  handler = thriftApp
  processor = Jetra::Thrift::Service::Processor.new(handler)
  transport = Thrift::ServerSocket.new(port)
  transportFactory = Thrift::FramedTransportFactory.new()
  server = Thrift::NonblockingServer.new(processor, transport, transportFactory)

  puts "Starting the server..."
  server.serve()

```

client端代码
```ruby

  

```

通过编写自定义适配器，你可以将jetra接口转化为需要的接口类型。此处只是拿thrift举例。




















