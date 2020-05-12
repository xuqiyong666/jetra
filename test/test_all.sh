#!/bin/sh


cd `pwd`/`dirname $0`

ruby base_application_test.rb
echo -e "\n\n"

ruby interface_test.rb
echo -e "\n\n"

ruby builder_call_test.rb
echo -e "\n\n"

ruby builder_interface_test.rb
echo -e "\n\n"

ruby another_application_test.rb
echo -e "\n\n"

ruby combiner_application_test.rb
echo -e "\n\n"

ruby complex_test.rb
echo -e "\n\n"