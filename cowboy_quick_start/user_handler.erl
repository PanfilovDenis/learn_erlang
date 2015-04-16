- module(user_handler).

- behavior(cowboy_http_handler).

- export([init/3, handle/2, terminate/3]).

init(_Transport, Req, _Options) ->
  {ok, Req, no_state}.

handle(Req, State) ->
  {Host, _} = cowboy_req:host(Req),
  {Path, _} = cowboy_req:path(Req),
  {Url, _} = cowboy_req:url(Req),
  {QweryString, _} = cowboy_req:qs(Req),
  {GetParams, _} = cowboy_req:qs_vals(Req),
  {ok, PostParams, _} = cowboy_req:body_qs(Req),
  {UserId, _} = cowboy_req:binding(user_id, Req),

  Reply = ["<h1>user handler</h1>",
            "<p>Host ", Host, "</p>",
            "<p>Path ", Path, "</p>",
            "<p>Url ", Url, "</p>",
            "<p>QweryString ", QweryString, "</p>",
            "<p>GetParams ", show_params(GetParams), "</p>",
            "<p>PostParams ", show_params(PostParams), "</p>",
            "<p>UserId ", UserId, "</p>"
          ],
  Reply2 = unicode:characters_to_binary(Reply),
  Headers = [{<<"Content-Type">>, <<"text/html;charset=UTF-8">>}],
  {ok, Req2} = cowboy_req:reply(200, Headers, Reply2, Req),
  {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.

show_params(Props) ->
  P = lists:map(fun({Key, Value}) -> ["<li><b>", Key, "</b>", Value, "</li>"] end, Props),
  ["<ul>", P, "</ul>"].
