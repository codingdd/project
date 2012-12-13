%%tcp_server监听参数
%%tcp_server监听参数
-define(TCP_OPTIONS,
		 [binary, {packet, 2}, 
		  {active, false},
		   {reuseaddr, true}, 
		  {nodelay, false}, 
		  {delay_send, false}, 
		  {send_timeout, 5000}, 
		  {keepalive, true},
 		  {packet_size, 100}, 
		  {exit_on_close, true}]).
%% 读空闲时间
-define(DELAY_TIME,60000).

-define(DD, 100).

-define(FF, 300).