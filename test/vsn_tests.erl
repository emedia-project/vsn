-module(vsn_tests).

-include_lib("eunit/include/eunit.hrl").

vsn_test_() ->
  {setup,
   fun setup/0, fun teardown/1,
   [
    ?_test(t_bump()),
    ?_test(t_match()),
    ?_test(t_max_version()),
    ?_test(t_min_version()),
    ?_test(t_max_expected()),
    ?_test(t_min_expected()),
    ?_test(t_compare()),
    ?_test(t_next())
   ]}.

setup() ->
  ok.

teardown(_) ->
  ok.

t_bump() ->
  ?assertMatch({ok, "2.0.0"}, vsn:bump(major, "1.2.3")),
  ?assertMatch({ok, "1.3.0"}, vsn:bump(minor, "1.2.3")),
  ?assertMatch({ok, "1.2.4"}, vsn:bump(patch, "1.2.3")),
  ?assertMatch({ok, "1.2.3"}, vsn:bump(patch, "1.2.3-pre")),
  ?assertMatch({ok, "1.2.4"}, vsn:bump(patch, "1.2.3+build")),
  ?assertMatch({ok, "1.2.3"}, vsn:bump(patch, "1.2.3-pre+build")).

t_match() ->
  ?assert(vsn:match("1.2.3", "=1.2.3")),
  ?assert(vsn:match("1.2.3", "==1.2.3")),
  ?assert(vsn:match("1.2.3", "== 1.2.3")),
  ?assert(vsn:match("1.2.3", ">=1.2.3")),
  ?assert(vsn:match("1.2.3", "=>1.2.3")),
  ?assert(vsn:match("1.2.3", "=>  1.2.3")),
  ?assert(vsn:match("1.2.3", " =>  1.2.3")),
  ?assert(vsn:match(" 1.2.3 ", " =>  1.2.3  ")),
  ?assert(vsn:match("1.2.3", "=<1.2.3")),
  ?assert(vsn:match("1.2.3", "<=1.2.3")),
  ?assert(vsn:match("1.2.3", "<= 1.2.3")),
  ?assert(vsn:match("1.2.3", ">1.2.2")),
  ?assert(vsn:match("1.2.3", "<1.2.4")),
  ?assert(vsn:match("1.2.3", ">1.2.3-pre")),
  ?assert(vsn:match("1.2.3", "<1.2.4-pre")),
  ?assert(vsn:match("1.2.3-pre", "=1.2.3-pre")),
  ?assert(vsn:match("1.2.3-pre", "==1.2.3-pre")),
  ?assert(vsn:match("1.2.3-pre1", ">1.2.3-pre")),
  ?assert(vsn:match("1.2.3-pre", "<1.2.3-pre1")),
  ?assert(vsn:match("1.2.3-alpha", "=1.2.3-alpha")),
  ?assert(vsn:match("1.2.3-a", "=1.2.3-alpha")),
  ?assert(vsn:match("1.2.3-b", ">1.2.3-alpha")),
  ?assert(vsn:match("1.2.3-beta", ">1.2.3-alpha")),
  ?assert(vsn:match("1.2.3-pre", ">1.2.3-alpha")),
  ?assert(vsn:match("1.2.3-1", ">1.2.3-alpha")),
  ?assert(vsn:match("1.2.3-1", ">1.2.3-pre")),
  ?assert(vsn:match("1.2.3-rc", ">1.2.3-pre")),
  ?assert(vsn:match("1.2.3-rc", ">1.2.3-1")),
  ?assert(vsn:match("1.2.3", "<1.3")),
  ?assert(vsn:match("1.2.3", ">1.2")),
  ?assert(vsn:match("1.2.3", ">1.2-pre")),
  ?assert(vsn:match("1.0.0", "~1.0.0")),
  ?assert(vsn:match("1.0.5", "~1.0.0")),
  ?assert(vsn:match("1.0.9", "~1.0.0")),
  ?assertNot(vsn:match("2.0.0", "~1.0.0")),
  ?assert(vsn:match("1.2.3", "~1")),
  ?assert(vsn:match("1.2.3", "~1.2")),
  ?assert(vsn:match("1.2.3", "~1.2.3")).

t_max_version() ->
  ?assertMatch("1.2.3", vsn:max_version(["0", "1", "1.2", "1.2.3", "1.2.3-pre"])).

t_min_version() ->
  ?assertMatch("1.2.3-1", vsn:min_version(["2", "1.2.4", "1.2.3", "1.2.3-1"])).

t_max_expected() ->
  ?assertMatch("1.2.3", vsn:max_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], ">1.2.2")),
  ?assertMatch("1.2.2", vsn:max_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], "=1.2.2")),
  ?assertMatch("1.0.9", vsn:max_expected(["1.2.3", "1.0.0", "1.0.9", "0.9.0"], "~1.0.0")),
  ?assertMatch(nil, vsn:max_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], "=1.2.7")),
  ?assertMatch(nil, vsn:max_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], ">1.2.7")),
  ?assertMatch(nil, vsn:max_expected(["1.2.3", "1.2.4", "3.9.1", "2.9.0"], "~1.1.0")).

t_min_expected() ->
  ?assertMatch("1.2.3-pre", vsn:min_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], ">1.2.2")),
  ?assertMatch("1.2.2", vsn:min_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], "=1.2.2")),
  ?assertMatch("1.0.0", vsn:min_expected(["1.2.3", "1.0.0", "1.0.9", "0.9.0"], "~1.0.0")),
  ?assertMatch(nil, vsn:min_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], "=1.2.7")),
  ?assertMatch(nil, vsn:min_expected(["1.2.3", "1.2.3-pre", "1.2.2", "1.2.0"], ">1.2.7")),
  ?assertMatch(nil, vsn:min_expected(["1.2.3", "1.2.4", "3.9.1", "2.9.0"], "~1.1.0")).
  
t_compare() ->
  % 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0
  ?assertMatch(-1, vsn:compare("1.0.0-alpha", "1.0.0-alpha.1")),
  ?assertMatch(-1, vsn:compare("1.0.0-alpha.1", "1.0.0-alpha.beta")),
  ?assertMatch(-1, vsn:compare("1.0.0-alpha.beta", "1.0.0-beta")),
  ?assertMatch(-1, vsn:compare("1.0.0-beta", "1.0.0-beta.2")),
  ?assertMatch(-1, vsn:compare("1.0.0-beta.2", "1.0.0-beta.11")),
  ?assertMatch(-1, vsn:compare("1.0.0-beta.11", "1.0.0-rc.1")),
  ?assertMatch(-1, vsn:compare("1.0.0-rc.1", "1.0.0")).

t_next() ->
  ?assertEqual("1.0.0", vsn:next("0.0.9", ["0.0.7", "0.0.8", "0.0.9", "1.0.0", "1.0.1", "1.1.0"])),
  ?assertEqual("1.0.0-alpha1", vsn:next("0.0.9", ["0.0.7", "0.0.8", "0.0.9", "1.0.0-pre", "1.0.0-alpha1", "1.0.0-alpha2", "1.0.0-beta1",  "1.0.0-rc0", "1.0.0", "1.0.1", "1.1.0"], unstable)),
  ?assertEqual("1.0.0", vsn:next("0.0.9", ["0.0.7", "0.0.8", "0.0.9", "1.0.0-pre", "1.0.0-alpha1", "1.0.0-alpha2", "1.0.0-beta1",  "1.0.0-rc0", "1.0.0", "1.0.1", "1.1.0"], stable)),
  ?assertEqual("1.0.0", vsn:next("0.0.9", ["0.0.7", "0.0.8", "0.0.9", "1.2.0-pre", "1.2.0-alpha1", "1.2.0-alpha2", "1.2.0-beta1",  "1.2.0-rc0", "1.0.0", "1.0.1", "1.1.0"], unstable)),
  ?assertEqual(nil, vsn:next("0.0.9", ["0.0.7", "0.0.8", "0.0.9", "0.0.9-rc1"])).

