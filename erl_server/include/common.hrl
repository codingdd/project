%%tcp_server监听参数
%%tcp_server监听参数
-define(TCP_OPTIONS,
		 [binary, {packet, 2}, 
		  {active, true},
		   {reuseaddr, true}, 
		  {nodelay, false}, 
		  {delay_send, true}, 
		  {send_timeout, 5000}, 
		  {keepalive, true},
		  {packet_size, 10}, 
		  {exit_on_close, true}]).