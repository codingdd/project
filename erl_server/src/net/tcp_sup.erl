%% @author Administrator
%% @doc @todo Add description to tcp_sup.
-module(tcp_sup).
-behaviour(supervisor).
-export([init/1]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

start_link() ->
	{ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),
	io:format("tcp_sup pid = ~p~n",[Pid]),{ok,Pid}.

init([]) ->
    Child_1 = {tcp_listener_sup,{tcp_listener_sup,start_link,[]},
	      permanent,2000,supervisor,[tcp_listener_sup]},
	Child_2 = {tcp_client_sup,{tcp_client_sup, start_link, []},
			  permanent, 2000, supervisor, [tcp_client_sup]},
    {ok, {{one_for_one,0,1}, [Child_1,Child_2]}}.


