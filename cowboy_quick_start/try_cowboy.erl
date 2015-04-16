- module(try_cowboy).

- export([start/0]).

start() ->
  io:format("start cowboy ~n"),
  ok = application:start(crypto),
  ok = application:start(ranch),
  ok = application:start(cowlib),
  ok = application:start(cowboy),

  Port = 8081,
  Routes = cowboy_router:compile(get_routes()),
  cowboy:start_http(http, 100, [{port, Port}], [{env, [{dispatch, Routes}]}]),

  io:format("cowboy started ~p~n", [Port]),
  ok.

get_routes() ->
  [{'_',
    [
     { "/", index_handler, []},
     { "/user/:user_id", user_handler, []},
     { "/static/[...]", cowboy_static, {dir, "./static"}},
     { '_', not_found_handler, []}
    ]
  }].
