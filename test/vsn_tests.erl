-module(vsn_tests).

-include_lib("eunit/include/eunit.hrl").

vsn_test_() ->
  {setup,
   fun setup/0, fun teardown/1,
   [
    ?_test(t_bump()),
    ?_test(t_match())
   ]}.

setup() ->
  ok.

teardown(_) ->
  ok.

t_bump() ->
  ?assertMatch("2.0.0", vsn:bump(major, "1.2.3")),
  ?assertMatch("1.3.0", vsn:bump(minor, "1.2.3")),
  ?assertMatch("1.2.4", vsn:bump(patch, "1.2.3")),
  ?assertMatch("1.2.3", vsn:bump(patch, "1.2.3-pre")),
  ?assertMatch("1.2.4", vsn:bump(patch, "1.2.3+build")),
  ?assertMatch("1.2.3", vsn:bump(patch, "1.2.3-pre+build")).

t_match() ->
  ?assert(vsn:match("1.2.3", "=1.2.3")),
  ?assert(vsn:match("1.2.3", ">=1.2.3")),
  ?assert(vsn:match("1.2.3", "=<1.2.3")),
  ?assert(vsn:match("1.2.3", ">1.2.2")),
  ?assert(vsn:match("1.2.3", "<1.2.4")),
  ?assert(vsn:match("1.2.3", ">1.2.3-pre")),
  ?assert(vsn:match("1.2.3", "<1.2.4-pre")),
  ?assert(vsn:match("1.2.3-pre", "=1.2.3-pre")),
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

