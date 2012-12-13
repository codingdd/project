%% @author Administrator
%% @doc @todo Add description to tcp_acceptor.

-module(tcp_acceptor).
-behaviour(gen_server).
-include("common.hrl").
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([start_link/1]).

-record(state, {listenSocket}).

start_link(ListenSocket) ->
	gen_server:start_link(?MODULE, ListenSocket, []).

init(ListenSocket) ->
	%% 通知开始接收连接请求
	gen_server:cast(self(), accept),
	{ok,#state{listenSocket=ListenSocket}}.


handle_call(Request, From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% 处理开始连接指令
handle_cast(accept, State) ->
	accept(State);

handle_cast(_Msg, State) ->
	{noreply, State}.

%% 接收到一个连接请求
handle_info({inet_async, ListenSocket, _Ref, {ok, ClientSocket}}, State = #state{listenSocket=ListenSocket}) ->
	case set_tcp_options(ListenSocket, ClientSocket) of
		ok -> ok;
		{error, Reason} ->  exit({set_sockopt, Reason})
	end,
	%% 启动一个tcp_client处理ClientScoket的消息
	start_tcp_client(ClientSocket),
	%% 继续接收下一个连接请求
	accept(State);			   

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, State) ->
    ok.

code_change(OldVsn, State, Extra) ->
    {ok, State}.

%% 私有函数

%% 异步等待一个连接
accept(State = #state{listenSocket=ListenSocket}) ->
    case prim_inet:async_accept(ListenSocket, -1) of
        {ok, _Ref} -> {noreply, State#state{listenSocket=ListenSocket}};
        Error     -> {stop, {cannot_accept, Error}, State}
    end.

%% 设置客户端socket的监听参数
set_tcp_options(ListenSocket, ClientSocket) ->
	inet_db:register_socket(ClientSocket, inet_tcp),
	case prim_inet:getopts(ListenSocket, [active, nodelay, keepalive, delay_send, priority, tos]) of
		{ok, Opts} -> 
			case prim_inet:setopts(ClientSocket, Opts) of
				ok -> ok;
				Error -> gen_tcp:close(ClientSocket), Error
			end;
		Error -> 
			gen_tcp:close(ClientSocket),
			Error
	end.

start_tcp_client(ClientSocket) ->
	%% 启动一个新的客户端
	{ok, Pid} = supervisor:start_child(tcp_client_sup, []),
	gen_tcp:controlling_process(ClientSocket, Pid),
	Pid ! {go, ClientSocket}.

