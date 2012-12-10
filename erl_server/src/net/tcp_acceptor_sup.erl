%% @author Administrator
%% @doc @todo Add description to tcp_accepter_sup.

-module(tcp_acceptor_sup).
-behaviour(supervisor).
-export([init/1]).

-export([start_link/0]).

start_link() ->
	io:format("tcp_acceptor_sup start ~n"),
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    AChild = {tcp_acceptor,{tcp_acceptor,start_link,[]},
	      permanent,2000,worker,[tcp_acceptor]},
    {ok,{{simple_one_for_one,0,1}, [AChild]}}.


