# 介绍

jetra是一个用于编写接口的微型框架，参考了sinatra的内部逻辑。sinatra封装了rack，所以只能用于写http接口。jetra可以理解为移除了rack层的sinatra。

## 安装

```bash
  gem install jetra
```

## 基本示例

首先写一个基本的接口类

```ruby

require "jetra"

class ApiInterface < Jetra::Base

  route "greeting" do
    "hello, world!"
  end

  route "repeat" do
    "you said `#{params["msg"]}`"
  end

end
```

然后可以这样调用

```ruby

ApiInterface.call("greeting") 
#<Jetra::Response:0x00007fef2a97b500 @status=0, @body="hello, world!", @headers=nil>

ApiInterface.call("repeat", "msg" => "I am fine")
#<Jetra::Response:0x00007fef2a97ace0 @status=0, @body="you said `I am fine`", @headers=nil>

```

## 封装接口

你可以封装为对应的接口类型，比如grpc,thrift,http，详见demo目录下的例子

运行demo步骤:

1. 首先需要安装运行示例所依赖的对应Gem
```
  gem install grpc
  gem install thrift
  gem install rack  #http接口
```

2. 启动服务端
```sh
  ruby server.rb
```

3. 客户端调用
```sh
  # 打开另一个终端
  ruby client.rb
```

注意，demo目录下的示例只为完成封装演示，并不是成熟的通用封装方案，请不要直接用到正式项目。

## 代码示例: 封装为http接口

```ruby

  ......

  require "rack"
  require "jetra/adapter/rack"
  RackApp = Jetra::RackAdapter.new(ApiInterface)

  Rack::Server.start(
    app: RackApp, :Port => 9292
  )
```

然后你就可以使用浏览器访问 http://localhost:9292/repeat?msg=hi,rack


## 代码示例: 封装为thrift接口

```sh
  gem install thrift
```

```ruby

  # server.rb

  ......

  require "jetra/adapter/thrift"

  thriftApp = Jetra::ThriftAdapter.new(ApiInterface)

  thirftServer = Jetra::ThriftServer.new(thriftApp, 9090)

  puts "Starting the server..."
  thirftServer.serve()

```

```ruby

  # client.rb

  require "jetra"
  require "jetra/adapter/thrift"

  thriftClient = Jetra::ThriftClient.new("localhost", 9090)

  request = Jetra::Thrift::Request.new
  request.route = "repeat"
  request.params = {msg: "hi,thrift"}.to_json

  response = thriftClient.call(request)
  # <Jetra::Thrift::Response status:0, body:"\"you said `hi,thrift`\"">

```

未完待续




















