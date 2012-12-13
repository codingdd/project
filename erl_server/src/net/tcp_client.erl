%% @author Administrator
%% @doc @todo Add description to tcp_client.


-module(tcp_client).

%% ====================================================================
%% API functions
%% ====================================================================
-include("common.hrl").
-export([start_link/0,init/0]).

start_link() ->
	{ok, proc_lib:spawn_link(?MODULE, init, [])}.

init() ->
	process_flag(trap_exit, true),
	receive
		{go, ClientSocket} -> loop(ClientSocket)	
	end.
%% Internal functions

%% 异步接收指定长度的消息
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
    case prim_inet:async_recv(Sock, Length, Timeout) of
        {error, Reason} -> throw({Reason});
        {ok, Res}       -> Res;
        Res             -> Res
    end.

%% 循环接收消息,DELAY_TIME时间内没有收到消息，连接进入空闲状态
loop(ClientSocket) ->
	io:format("wait for message form client: ~n"),
	Ref = async_recv(ClientSocket, 0, ?DELAY_TIME),
	receive
		{inet_async, ClientSocket, Ref, {ok, <<Data:16>>}} -> 
			io:format("received data=~p~n",[Data]), 
			loop(ClientSocket);
		{inet_async, ClientSocket, Ref, {error, timeout}} ->
			io:format("error timeout "),
			gen_tcp:close(ClientSocket);
		_Msg -> io:format("_Msg:~p~n",[_Msg]),
				gen_tcp:close(ClientSocket)
	end.


