%% @author Administrator
%% @doc @todo Add description to net_tcp_listener_sup.

-module(tcp_listener_sup).
-behaviour(supervisor).
-export([init/1]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

start_link() ->
	io:format("tcp_listener_sup start ~n"),
	supervisor:start_link(?MODULE, [10, 1234]).

init([AcceptorNum, Port]) ->
	io:format("tcp_listener_sup init ~n"),
	Child_1 = {tcp_acceptor_sup,{tcp_acceptor_sup, start_link,[]}, transient, 2000, supervisor, [tcp_acceptor]},
	Child_2 = {tcp_listener,{tcp_listener,start_link,[AcceptorNum, Port]},
	      transient ,2000,worker,[tcp_listener]},
 	{ok, {{one_for_all, 10, 10}, [Child_1, Child_2]}}.
%% 	{ok,
%%         {{one_for_all, 10, 10},
%%             [
%%                 {
%%                     tcp_listener,
%%                     {tcp_listener, start_link, [AcceptorNum, Port]},
%%                     transient,
%%                     100,
%%                     worker,
%%                     [tcp_listener]
%%                 }
%%             ]
%%         }
%%     }.


