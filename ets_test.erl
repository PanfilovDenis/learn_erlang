-module(ets_test).
-include_lib("stdlib/include/ms_transform.hrl").

-export([init/0, test_select/0, select/1]).


init() ->
  T = ets:new(my_ets, [{keypos, 2}, named_table]),
  ets:insert(T, {user, 5, "Hel2", 23}),
  ets:insert(T, {user, 1, "Hel", 5}),
  ets:insert(T, {user, 2, "Den", 22}),
  T.

test_select() ->
  Pattern = ets:fun2ms(
    fun({user, Id, Name, Age})
      when Age > 20 ->
        {Id, Name}
    end),
  Pattern.

select(Pattern) ->
  ets:select(my_ets, Pattern).
