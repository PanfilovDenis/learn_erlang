-module(chemp).
-export([init/0, filter/1]).

init() ->
  [
    {team, "Cool Bools",
      [{player, "Bill", 35},
      {player, "Bob", 24},
      {player, "BB", 5},
      {player, "TT", 0}]},
    {team, "Good Gays",
      [{player, "Bill2", 11},
      {player, "Bob2", 22},
      {player, "BB2", 3},

      {player, "TT2", 44}]},
    {team, "Crazy Frogs",
      [{player, "Bill3", 20},
      {player, "Bob3", 8},
      {player, "BB3", 5},
      {player, "TT3", 4}]},
    {team, "Mighty Dogs",
      [{player, "Bill4", 40},
      {player, "Bob4", 0},
      {player, "BB4", 50},
      {player, "TT4", 55}]}
  ].

% выводить еще и название команды
filter(Chemp) ->
  F = fun({team, _, Players} = Team) ->

    F2 = fun({player, _, Force} = Player) ->
      Force > 10
    end,

    lists:filter(F2, Players)
  end,

  FilteredPlayers = lists:map(F, Chemp),

  lists:filter(fun(P) -> length(P) >= 3 end, FilteredPlayers).
