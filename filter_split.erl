-module(filter_split).
-export([init/0, filter_female/1, get_names/1, split_by_age/2, get_female_names/1, get_stats/1]).

init() ->
  [{user, 1, "bob", female, 13},
  {user, 2, "den", female, 22},
  {user, 3, "test", male, 40},
  {user, 4, "and", female, 25}].

filter_female(Users) ->
  filter_female(Users, []).

filter_female([], Acc) -> lists:reverse(Acc);

filter_female([{user, _, _, Gender, _} | Rest], Acc)
  when Gender =:= male ->
  filter_female(Rest, Acc);

filter_female([{user, _, _, Gender, _} = User | Rest], Acc)
  when Gender =:= female ->
  filter_female(Rest, [User | Acc]).

get_names(Users) ->
  get_names(Users, []).

get_names([], Acc) -> Acc;

get_names([User | Rest], Acc) ->
  {user, _, Name, _, _} = User,
  get_names(Rest, [Name | Acc]).


split_by_age(Users, Age) ->
  split_by_age(Users, Age, {[],[]}).

split_by_age([], _Age, Acc) -> Acc;
split_by_age([User | Rest], Age, {L1, L2}) ->
  {user, _, _, _, UserAge} = User,
  if
    UserAge > Age ->
      split_by_age(Rest, Age, {L1, [User | L2]});
    true ->
      split_by_age(Rest, Age, {[User | L1], L2})
  end.


get_female_names(Users) ->
  F = fun({user, _Id, Name, Gender, _Age}) ->
    case Gender of
      male -> false;
      female -> {true, Name}
    end
  end,
  lists:filtermap(F, Users).


% Релизовать свертку по возрасту ({[младше][старше]})
% split_by_age(Users, Age) ->

get_stats(Users) ->
  Stat0 = {0, 0, 0, 0.0},
  F = fun(User, Acc) ->
    {user, _, _, Gender, Age} = User,
    {TotalUsers, TotalMale, TotalFemale, TotalAge } = Acc,
    {TotalMale2, TotalFemale2} =
      case Gender of
        male -> {TotalMale + 1, TotalFemale};
        female -> {TotalMale, TotalFemale + 1}
      end,
      {TotalUsers + 1, TotalMale2, TotalFemale2, TotalAge + Age}
    end,

    {TU, TM, TF, TA} = lists:foldl(F, Stat0, Users).
