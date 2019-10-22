
require 'grpc'
require "jetra/adapter/grpc"
require "google/protobuf/well_known_types"

# params = Google::Protobuf::Map.new(:string, :string)
# params["msg"] = "ok,grpc!"

# anyParams = Google::Protobuf::Any.new
# anyParams.pack(params)

# p anyParams
# p anyParams.to_proto

# ptoString = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.StringValue").msgclass
# p ptoString

ptoBody = Google::Protobuf::Value.new
ptoBody.from_ruby("body is nice")

p ptoBody

anyBody = Google::Protobuf::Any.new
anyBody.pack(ptoBody)

p anyBody

p anyBody.to_proto