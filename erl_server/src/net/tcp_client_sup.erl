%% @author Administrator
%% @doc @todo Add description to tcp_client_sup.


-module(tcp_client_sup).
-behaviour(supervisor).
-export([init/1]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

start_link() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, []).

%% ====================================================================
%% Behavioural functions 
%% ====================================================================

init([]) ->
    AChild = {tcp_client,{tcp_client,start_link,[]},
	      temporary,2000,worker,[tcp_client]},
    {ok,{{simple_one_for_one,0,1}, [AChild]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================


