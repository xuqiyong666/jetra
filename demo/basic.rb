
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

# puts "finish"




