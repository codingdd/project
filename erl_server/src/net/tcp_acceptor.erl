%% @author Administrator
%% @doc @todo Add description to tcp_acceptor.

-module(tcp_acceptor).
-behaviour(gen_server).
-include("common.hrl").
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([start_link/1,test_client/0]).

-record(state, {listenSocket}).

start_link(ListenSocket) ->
	gen_server:start_link(?MODULE, ListenSocket, []).

init(ListenSocket) ->
 case prim_inet:async_accept(ListenSocket, -1) of
        {ok, Ref} -> io:format("ready to ...");
        Error     ->  io:format("ready to error")
    end,
    {ok, #state{listenSocket=ListenSocket}}.


handle_call(Request, From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(Msg, State) ->
    {noreply, State}.

handle_info({inet_async, ListenSocket, Ref, {ok, Sock}}, State = #state{listenSocket=ListenSocket}) ->
   io:format("连接成功。。。。~p~n",[ListenSocket]),{noreply, State#state{listenSocket = ListenSocket}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, State) ->
    ok.

code_change(OldVsn, State, Extra) ->
    {ok, State}.

test_client() ->
	gen_tcp:connect('localhost', 1234, ?TCP_OPTIONS).