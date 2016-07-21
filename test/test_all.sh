#!/bin/sh


cd `pwd`/`dirname $0`

ruby base_application_test.rb
echo "\n\n"

ruby extend_application_test.rb
echo "\n\n"

ruby second_extend_application_test.rb
echo "\n\n"

ruby interface_test.rb
echo "\n\n"

ruby builder_call_test.rb
echo "\n\n"

ruby builder_interface_test.rb
echo "\n\n"