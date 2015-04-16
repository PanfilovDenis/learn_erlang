-module(my_gen_server).
-export([start/0, server/1, add_user/2, stop/1, get_users/1, get_users_count/1, crush/1]).

start() ->
  io:format("start ~p~n", [self()]),
  InitialState = [],
  spawn(?MODULE, server, [InitialState]).


add_user(Pid, User) ->
  Pid ! {add_user, User}.

stop(Pid) ->
  Pid ! stop.

crush(Pid) ->
  call(Pid, crush).

get_users(Pid) ->
  call(Pid, get_users).

get_users_count(Pid) ->
  call(Pid, get_users_count).

call(Pid, Msg) ->
  Monitor = erlang:monitor(process, Pid),
  % Ref = make_ref(),
  Pid ! {Msg, self(), Monitor},
  receive
    {reply, Monitor, Users} ->
      erlang:demonitor(Monitor, [flush]),
      Users;
    {'DOWN', Monitor, _, _, Error} ->
      {error, Error}
  after 500 ->
    erlang:demonitor(Monitor, [flush]),
    no_reply
  end.

server(State) ->
  io:format("~p enters loop version 4 ~n", [self()]),
  receive
    {add_user, User} -> NewState = [User | State],
      ?MODULE:server(NewState);

    show_users -> io:format("user is ~p~n", [State]),
      ?MODULE:server(State);

    {delete_user, User} -> NewState = lists:delete(User, State),
      ?MODULE:server(NewState);

    {get_users, From, Ref} ->
      From ! {reply, Ref, State},
      ?MODULE:server(State);

    {get_users_count, From, Ref} ->
      From ! {reply, Ref, length(State)},
      ?MODULE:server(State);

    {crush, _, _} -> io:format("im crush"),
      600 /0,
      ?MODULE:server(State);

    stop -> io:format("server stop ~p", [self()]);

    Msg -> io:format("~p receive ~p~n", [self(), Msg]),
      ?MODULE:server(State)
  end.
