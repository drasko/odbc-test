%%%-------------------------------------------------------------------
%% @doc odbc_test top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(odbc_test_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional



% init([]) ->
%     SupFlags = #{strategy => one_for_all,
%                  intensity => 0,
%                  period => 1},
%     ChildSpecs = [
%         #{id => odbc_worker,
%           start => {odbc_test_worker, start_link, []},
%           restart => permanent,
%           shutdown => brutal_kill,
%           type => worker}
%     ],
%     {ok, {SupFlags, ChildSpecs}}.

% init([]) ->
%     SupFlags = #{strategy => one_for_one, intensity => 0, period => 1},
%     WorkerSpecs = lists:map(fun(_) ->
%         WorkerId = make_ref(), % Generate a unique reference (PID)
%         {worker,
%          WorkerId,
%          odbc_test_worker,
%          start_link,
%          [],
%          permanent,
%          0, % Max restart frequency in milliseconds
%          worker,
%          [odbc_test_worker]}
%     end, lists:seq(1, 100)),
%     {ok, {SupFlags, WorkerSpecs}}.


init([]) ->
    SupFlags = #{strategy => one_for_one, intensity => 0, period => 1},
    WorkerSpecs = [{odbc_test_worker, {odbc_test_worker, start_link, []}, permanent, 2000, worker, [odbc_test_worker]}],
    {ok, {SupFlags, WorkerSpecs}}.



%% internal functions
