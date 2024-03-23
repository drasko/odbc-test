%%%-------------------------------------------------------------------
%% @doc odbc_test public API
%% @end
%%%-------------------------------------------------------------------

-module(odbc_test_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    application:start(odbc), % Start the ODBC application
    odbc_test_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
