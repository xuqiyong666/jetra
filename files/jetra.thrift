
namespace * Jetra.Thrift

struct Request {
  1: string route,
  2: string params
}

struct Response {
  1: i32 status,
  2: string body
}


service Service {

   Response call(1:Request request)

}