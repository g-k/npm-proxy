#!/usr/bin/env expect
set registry [lindex $argv 0]

spawn npm adduser --registry=$registry
expect "Username:"
send "test\n"
expect "Password:"
send "test\n"
expect "Email:"
send "test@example.com\n"
expect eof
