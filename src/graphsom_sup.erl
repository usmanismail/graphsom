
-module(graphsom_sup).

-behaviour(supervisor).

%% API
-export([start_link/1, start_link/5]).

%% Supervisor callbacks
-export([init/1]).

%% Include

-include("graphsom.hrl").

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% Default values for report interval, host and port

-define(REPORT_INTERVAL_MS, 30000).
-define(GRAPHITE_HOST, "localhost").
-define(GRAPHITE_PORT, 2003).
-define(GRAPHITE_PREFIX, "graphsom.").
-define(SYSTEM_STATS, [memory, system_info, statistics, process_info, port_info]).



%% ===================================================================
%% API functions
%% ===================================================================


-spec start_link(config()) -> {ok, pid()}.

start_link(Config) ->
    start_link(value(report_interval, Config), 
               value(graphite_host, Config), 
               value(graphite_port, Config),
               value(graphite_prefix, Config), 
               value(system_stats, Config)).

-spec start_link(pos_integer(), string(), integer(), string(), system_stats_type()) -> {ok, pid()}.

start_link(ReportIntervalMs, GraphiteHost, GraphitePort, Prefix, SystemStats) ->
    io:format("graphsom_sup: systemStats: ~w ~n", [SystemStats]),
    supervisor:start_link({local, ?MODULE}, ?MODULE,
                          [ReportIntervalMs, GraphiteHost, GraphitePort, Prefix, SystemStats]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================


-spec init(list()) -> {ok, term()}.

init([ReportIntervalMs, GraphiteHost, GraphitePort, Prefix, SystemStats]) ->
    %% adding folsom_sup and graphsom to graphsom_sup's supervision tree
    Folsom = {folsom,
              {folsom_sup, start_link, []},
              permanent,
              5000,
              supervisor,
              [folsom_sup]
             },
    GraphsomTimer = {graphsom_timer,
                      {graphsom_timer, start_link, 
                       [ReportIntervalMs,GraphiteHost, GraphitePort, Prefix, SystemStats]},
                      permanent, 
                      5000, 
                      worker, 
                      [graphsom_timer]},
    {ok, { {one_for_one, 100, 10}, [Folsom, GraphsomTimer]} }.

%% private functions

-spec value(atom(), config()) -> term().

value(report_interval, Config) ->
    proplists:get_value(report_interval, Config, ?REPORT_INTERVAL_MS);

value(graphite_host, Config) ->
    proplists:get_value(graphite_host, Config, ?GRAPHITE_HOST);

value(graphite_port, Config) ->
    proplists:get_value(graphite_port, Config, ?GRAPHITE_PORT);

value(system_stats, Config) ->
    proplists:get_value(system_stats, Config, ?SYSTEM_STATS);

value(graphite_prefix, Config) ->
    proplists:get_value(graphite_prefix, Config, ?GRAPHITE_PREFIX);

value(test_value, Config) ->
    proplists:get_value(test_value, Config).
