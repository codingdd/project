%% @author Administrator
%% @doc @todo Add description to test.


-module(test).

%% ====================================================================
%% API functions
%% ====================================================================
-include("common.hrl").
-export([test_client/0,loop/1,send/0]).
-record(state,{client}).

test_client() ->
	case gen_tcp:connect('localhost', 1234, ?TCP_OPTIONS) of
		{ok, Socket} -> Pid = spawn(?MODULE,loop,[Socket]), register(gogo, Pid)
	end.

send() ->
	gogo ! message.

loop(Socket) ->
	receive
		_Info -> 
			case gen_tcp:send(Socket, <<1111:16>>) of
				ok ->
					loop(Socket);
				{error, Reason} -> io:format(Reason)
			end
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================


