%% @author Gregoire Lejeune <gregoire.lejeune@free.fr>
%%
%% @doc
%%
%% The vsn module allow you to manipulate string versions.
%%
%% A version string should normally be a series of numbers
%% separated by periods.
%%
%% If any part contains letters then that version is considered prerelease. 
%% Versions with a prerelease part in the Nth part sort less than versions 
%% with N-1parts. 
%%
%% Prerelease are sorted following this order :
%% 
%% <pre>alpha = a &lt; beta = b &lt; pre = any()</pre>
%%
%% The default prefix is pre :
%%
%% <pre>1.0-1 = 1.0-pre1</pre>
%%
%% Prereleases sort between real releases :
%%
%% <pre>1.0 &gt; 1.0.pre &gt; 1.0.b &gt; 1.0.a</pre>
%%
%% You can also give a build value by adding it at the end, separated
%% plus (+) :
%%
%% <pre>1.0.2-pre1+build1</pre>
%% @end
-module(vsn).

-export([
         match/2,
         bump/2,
         compare/2,
         parse/1,
         max_version/1,
         max_version/2,
         max_expected/2,
         min_version/1,
         min_version/2,
         min_expected/2
        ]).

-type version() :: string().
-type expect() :: string().
-type type() :: major | minor | match.
-type prefix() :: alpha | a | beta | b | pre.
-type pre() ::  nil | {prefix(), string()}.
-type parsed_version() :: #{major => integer(), minor => integer(), patch => integer(), v => version(), pre => pre(), build => string(), d => integer()}.

-spec match(version(), expect()) -> true | false.
match(Version, [$>, $=|Expected]) ->
  sup(Version, Expected) orelse equal(Version, Expected);
match(Version, [$=, $<|Expected]) ->
  inf(Version, Expected) orelse equal(Version, Expected);
match(Version, [$=|Expected]) ->
  equal(Version, Expected);
match(Version, [$>|Expected]) ->
  sup(Version, Expected);
match(Version, [$<|Expected]) ->
  inf(Version, Expected);
match(Version, [$~|Expected]) ->
  tild(Version, Expected);
match(Version, Expected) ->
  equal(Version, Expected).

-spec bump(type(), version()) -> {ok, version()} | {error, any()}.
bump(Type, Version) ->
  case parse(Version) of
    {ok, #{major := Major,
           minor := Minor,
           patch := Patch,
           v := V,
           pre := Pre, 
           build := _, 
           d := _}} ->
      case Type of
        major ->
          {ok, lists:flatten(io_lib:format("~w.0.0", [Major + 1]))};
        minor ->
          {ok, lists:flatten(io_lib:format("~w.~w.0", [Major, Minor + 1]))};
        _ ->
          case Pre of
            nil -> 
              {ok, lists:flatten(io_lib:format("~w.~w.~w", [Major, Minor, Patch + 1]))};
            _ ->
              {ok, V}
          end
      end;
    E -> E
  end.

-spec compare(version(), version()) -> 0 | -1 | 1 | {error, any()}.
compare(Version, Expected) ->
  case parse(Version) of
    {ok, #{major := _VMajor,
           minor := _VMinor,
           patch := _VPath,
           v := VVersion, 
           pre := VPre, 
           build := VBuild, 
           d := _VD}} ->
      case parse(Expected) of
        {ok, #{major := _EMajor,
               minor := _EMinor,
               patch := _EPatch,
               v := EVersion, 
               pre := EPre, 
               build := EBuild, 
               d := _ED}} ->
          case {compare_v(VVersion, EVersion), compare_p(VPre, EPre), compare_v(VBuild, EBuild)} of
            {0, 0, 0} -> 0;
            {1, _, _} -> 1;
            {0, 1, _} -> 1;
            {0, 0, 1} -> 1;
            _ -> -1
          end;
        _ -> {error, invalid_version_2}
      end;
    _ -> {error, invalid_version_1}
  end.

-spec parse(version()) -> {ok, parsed_version()} | {error, any()}.
parse(Version) ->
  Re = "^v?(?<version>(?<major>\\d+)\.?(?<minor>\\d+)?\.?(?<patchlevel>\\d+)?)(?<pre>-[0-9A-Za-z-\.]+)?(?<build>\\+[0-9A-Za-z-\.]+)?\$",
  case re:run(Version, Re, [{capture, [major, minor, patchlevel, version, pre, build], list}]) of
    {match, [X0, Y0, Z0, V, Pre, Build]} ->
      {ok, #{major => to_integer(X0),
             minor => to_integer(Y0),
             patch => to_integer(Z0),
             d => length([E||E<-[X0, Y0, Z0], E =/= ""]),
             v => V,
             pre => parse_pre(Pre),
             build => parse_build(Build)}};
    nomatch ->
      {error, invalid_version}
  end.

-spec max_version([version()]) -> version() | {error, any()}.
max_version([V|Versions]) ->
  lists:foldl(fun max_version/2, V, Versions).

-spec max_version(version(), version()) -> version() | {error, any()}.
max_version(Version1, Version2) ->
  case compare(Version1, Version2) of
    -1 -> Version2;
    0 -> Version1;
    1 -> Version1;
    E -> E
  end.

-spec max_expected([version()], expect()) -> version() | nil.
max_expected(Versions, Expected) ->
  mm_expected(Versions, Expected, fun max_version/2).

-spec min_version([version()]) -> version() | {error, any()}.
min_version([V|Versions]) ->
  lists:foldl(fun min_version/2, V, Versions).

-spec min_version(version(), version()) -> version() | {error, any()}.
min_version(Version1, Version2) ->
  case compare(Version1, Version2) of
    1 -> Version2;
    0 -> Version1;
    -1 -> Version1;
    E -> E
  end.

-spec min_expected([version()], expect()) -> version() | nil.
min_expected(Versions, Expected) ->
  mm_expected(Versions, Expected, fun min_version/2).

% private

mm_expected(Versions, Expected, Fun) ->
  lists:foldl(fun(V, M) ->
                  case {M, match(V, Expected)} of
                    {nil, true} -> V;
                    {_, true} -> Fun(V, M);
                    _ -> M
                  end
              end, nil, Versions).

equal(Version, Expected) ->
  compare(Version, Expected) =:= 0.

tild(Version, Expected) ->
  case compare(Version, Expected) of
    0 -> true;
    -1 -> false;
    1 -> 
      {ok, #{major := _,
             minor := _,
             patch := _,
             v := _,
             pre := _,
             build := _,
             d := D}} = parse(Expected),
      {ok, MaxExpected} = if
                            D =:= 3 ->
                              bump(minor, Expected);
                            true ->
                              bump(major, Expected)
                          end,
      case compare(Version, MaxExpected) of
        1 -> false;
        _ -> true
      end
  end.

sup(Version, Expected) ->
  compare(Version, Expected) =:= 1.

inf(Version, Expected) ->
  compare(Version, Expected) =:= -1.

compare_v(nil, nil) -> 0;
compare_v(nil, _) -> -1;
compare_v(_, nil) -> 1;
compare_v(V, E) ->
  if 
    V > E -> 1;
    V < E -> -1;
    true -> 0
  end.

compare_p(nil, nil) -> 0;
compare_p(nil, _) -> 1;
compare_p({P, V}, {P, E}) ->
  compare_v(V, E);
compare_p({a, V}, {alpha, E}) ->
  compare_v(V, E);
compare_p({alpha, V}, {a, E}) ->
  compare_v(V, E);
compare_p({b, V}, {beta, E}) ->
  compare_v(V, E);
compare_p({beta, V}, {b, E}) ->
  compare_v(V, E);
compare_p({b, _}, {a, _}) -> 1;
compare_p({b, _}, {alpha, _}) -> 1;
compare_p({beta, _}, {a, _}) -> 1;
compare_p({beta, _}, {alpha, _}) -> 1;
compare_p({pre, _}, {a, _}) -> 1;
compare_p({pre, _}, {alpha, _}) -> 1;
compare_p({pre, _}, {b, _}) -> 1;
compare_p({pre, _}, {beta, _}) -> 1;
compare_p({rc, _}, {a, _}) -> 1;
compare_p({rc, _}, {alpha, _}) -> 1;
compare_p({rc, _}, {b, _}) -> 1;
compare_p({rc, _}, {beta, _}) -> 1;
compare_p({rc, _}, {pre, _}) -> 1;
compare_p(_, _) -> -1.

to_integer([]) ->
  nil;
to_integer(X) ->
  list_to_integer(X).

parse_pre([]) ->
  nil;
parse_pre(Pre) ->
  Re = "(?<pre>-[a-z]+)?(?<sep>[\.|-])?(?<num>[0-9A-Za-z-\.]+)?",
  case re:run(Pre, Re, [{capture, [pre, sep, num], list}]) of
    {match, [[$-|Prefix], Sep, Value]} -> build_pre(Prefix, Value, Sep);
    {match, [[], _, Value]} -> {pre, Value};
    nomatch -> {pre, Pre}
  end.

build_pre(Prefix, Value, Sep) ->
  case include([alpha, a, beta, b, pre, rc], prefix_to_atom(Prefix)) of
    {ok, Pre} -> {Pre, Value};
    false -> {pre, Prefix ++ Sep ++ Value}
  end.


include(List, E) when is_list(List) ->
  case lists:any(fun(Elem) -> Elem =:= E end, List) of
    true -> {ok, E};
    _ -> false
  end.

prefix_to_atom("") -> pre;
prefix_to_atom(P) -> list_to_atom(P).

parse_build([]) ->
  nil;
parse_build([$+|Rest]) ->
  Rest.

