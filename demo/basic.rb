
#首先写一个基本的接口类

require "jetra"

class ApiInterface < Jetra::Base

  route :greeting do
    "hello, world!"
  end

  route :repeat do
    "you said `#{params[:msg] || "nothing"}`"
  end

end

#然后就可以这样调用
ApiInterface.call(:greeting) 
#=> #<Jetra::Response:0x007fe1b68a5af8 @status=0, @body="hello, world!">

ApiInterface.call(:repeat, msg: "I am fine") 
#=> #<Jetra::Response:0x007fc1a8897be8 @status=0, @body="you said `I am fine`">

ApiInterface.call(:repeat)
#=> #<Jetra::Response:0x007f804b07f8a0 @status=0, @body="you said `nothing`">


#或者使用to_app，让方法调用更舒服
App = ApiInterface.to_app

App.greeting
#=> #<Jetra::Response:0x007fa4b4093868 @status=0, @body="hello, world!">

App.repeat(msg: "I am great")
#=> #<Jetra::Response:0x007fed3508ec90 @status=0, @body="you said `I am great`">

App.repeat
#=> #<Jetra::Response:0x007fd92f88dc08 @status=0, @body="you said `nothing`">


#以上示例是程序内部调用，那么怎么才能支持远程调用？

#方法1: 转化为http接口

require "rack"
require "jetra/adapter/rack"
RackApp = Jetra::RackAdapter.new(ApiInterface)

Rack::Server.start(
  app: RackApp, :Port => 9292
)

#试试访问 http://localhost:9292/repeat?msg=work?


#转化为Rack应用后，你可以使用你喜欢的Thin/Unicorn/Puma来运行。

#方法2: 转化为thrift接口

#通过编写自定义适配器，你可以将jetra接口转化为需要的接口类型。此处只是拿thrift举例。



# puts "finish"




