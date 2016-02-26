PROJECT = vsn

DEP_PLUGINS = mix.mk
BUILD_DEPS = mix.mk
ELIXIR_VERSION = ~> 1.2
ELIXIR_BINDINGS = vsn

dep_mix.mk = git https://github.com/botsunit/mix.mk.git master

include erlang.mk
