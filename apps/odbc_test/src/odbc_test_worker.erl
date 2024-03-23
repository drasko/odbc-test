-module(odbc_test_worker).
-behaviour(gen_server).

-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {connection}).

%% API
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% Gen Server Callbacks
init([]) ->
    io:format("Initializing odbc_test_worker~n"),
    ConnectionStr = "Driver=PostgreSQL ANSI;Server=localhost;Port=5432;Database=zenith;Uid=drasko;Pwd=Testera011;MaxPoolSize=10;MinPoolSize=2;Pooling=true;",
    {ok, Conn} = odbc:connect(ConnectionStr, []),
    io:format("Connected to database~n"),
    {ok, #state{connection = Conn}}.

handle_call({execute_query, Query}, _From, State) ->
    io:format("Handling execute_query call: ~s~n", [Query]),
    Conn = State#state.connection,
    io:format("Executing SQL query: ~s~n", [Query]),
    {selected, Columns, Rows} = odbc:sql_query(Conn, Query),
    Result = {Columns, Rows},
    io:format("Query result: ~p~n", [Result]),
    {reply, Result, State};

handle_call(_Request, _From, State) ->
    io:format("Handling unknown call~n"),
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    io:format("Handling cast message~n"),
    {noreply, State}.

handle_info(_Info, State) ->
    io:format("Handling info message~n"),
    {noreply, State}.

terminate(_Reason, State) ->
    io:format("Terminating odbc_test_worker~n"),
    odbc:disconnect(State#state.connection),
    ok.

code_change(_OldVsn, State, _Extra) ->
    io:format("Code change in odbc_test_worker~n"),
    {ok, State}.
