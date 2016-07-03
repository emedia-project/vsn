# File: Vsn.ex
# This file was generated from vsn.beam
# Using rebar3_elixir (https://github.com/botsunit/rebar3_elixir)
# MODIFY IT AT YOUR OWN RISK AND ONLY IF YOU KNOW WHAT YOU ARE DOING!
defmodule Vsn do
  def unquote(:"match")(arg1, arg2) do
    :erlang.apply(:"vsn", :"match", [arg1, arg2])
  end
  def unquote(:"bump")(arg1, arg2) do
    :erlang.apply(:"vsn", :"bump", [arg1, arg2])
  end
  def unquote(:"compare")(arg1, arg2) do
    :erlang.apply(:"vsn", :"compare", [arg1, arg2])
  end
  def unquote(:"parse")(arg1) do
    :erlang.apply(:"vsn", :"parse", [arg1])
  end
  def unquote(:"max_version")(arg1) do
    :erlang.apply(:"vsn", :"max_version", [arg1])
  end
  def unquote(:"max_version")(arg1, arg2) do
    :erlang.apply(:"vsn", :"max_version", [arg1, arg2])
  end
  def unquote(:"max_expected")(arg1, arg2) do
    :erlang.apply(:"vsn", :"max_expected", [arg1, arg2])
  end
  def unquote(:"min_version")(arg1) do
    :erlang.apply(:"vsn", :"min_version", [arg1])
  end
  def unquote(:"min_version")(arg1, arg2) do
    :erlang.apply(:"vsn", :"min_version", [arg1, arg2])
  end
  def unquote(:"min_expected")(arg1, arg2) do
    :erlang.apply(:"vsn", :"min_expected", [arg1, arg2])
  end
end
