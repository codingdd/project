%% @author codingdd
%% @doc @todo Add description to net_tcp_listener.
-module(tcp_listener).
-behaviour(gen_server).
-include("common.hrl").
-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(AcceptorNum, Port) ->
	io:format("tcp_listener start ~n"),
	{ok,Pid} = gen_server:start_link(?MODULE, {AcceptorNum, Port}, []),
	io:format("tcp_listnener pid = ~p~n",[Pid]),
	{ok, Pid}.
	
init({AcceptorNum, Port}) ->
	io:format("tcp_listener init ~n"),
	process_flag(trap_exit, true),
	case gen_tcp:listen(Port, ?TCP_OPTIONS) of
		{ok,ListenSocket} ->
			lists:foreach(fun(_) ->
								  supervisor:start_child(tcp_acceptor_sup, [ListenSocket])
						  end, 
						  lists:duplicate(AcceptorNum, dummy)),
				{ok,ListenSocket};
			 {error, Reason} -> 
				 {stop, {cannot_listen, Reason}}	 
	end.

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    %{ok, {IPAddress, Port}} = inet:sockname(State),
    gen_tcp:close(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
