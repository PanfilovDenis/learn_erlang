- module(not_found_handler).

- behavior(cowboy_http_handler).

- export([init/3, handle/2, terminate/3]).

init(_Transport, Req, _Options) ->
  {ok, Req, no_state}.

handle(Req, State) ->
  Reply = <<"Not found">>,
  Headers = [{<<"Content-Type">>, <<"text/html;charset=UTF-8">>}],
  {ok, Req2} = cowboy_req:reply(404, Headers, Reply, Req),
  {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.
