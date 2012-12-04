%% @author codingdd
%% @doc @todo Add description to net_tcp_listener.
-module(net_tcp_listener).
-behaviour(gen_event).
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).

start_link(AcceptAccount,Port) ->
	gen_server:start_link(?MODULE,[AcceptAccount,Port]).
%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {}).

init([]) ->
    {ok, #state{}}.

handle_event(Event, State) ->
    {ok, State}.


handle_call(Request, State) ->
    Reply = ok,
    {ok, Reply, State}.


handle_info(Info, State) ->
    {ok, State}.


terminate(Arg, State) ->
    ok.


code_change(OldVsn, State, Extra) ->
    {ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================


