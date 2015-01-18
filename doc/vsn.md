

# Module vsn #
* [Description](#description)
* [Data Types](#types)
* [Function Index](#index)
* [Function Details](#functions)


.
__Authors:__ Gregoire Lejeune ([`gregoire.lejeune@free.fr`](mailto:gregoire.lejeune@free.fr)).
<a name="description"></a>

## Description ##

The vsn module allow you to manipulate string versions.



A version string should normally be a series of numbers
separated by periods.



If any part contains letters then that version is considered prerelease.
Versions with a prerelease part in the Nth part sort less than versions
with N-1parts.



Prerelease are sorted following this order :



```

  alpha = a < beta = b < pre = any()
```



The default prefix is pre :



```

  1.0-1 = 1.0-pre1
```



Prereleases sort between real releases :



```

  1.0 > 1.0.pre > 1.0.b > 1.0.a
```



You can also give a build value by adding it at the end, separated
plus (+) :



```

  1.0.2-pre1+build1
```

<a name="types"></a>

## Data Types ##




### <a name="type-expect">expect()</a> ###



<pre><code>
expect() = string()
</code></pre>





### <a name="type-parsed_version">parsed_version()</a> ###



<pre><code>
parsed_version() = #{major =&gt; integer(), minor =&gt; integer(), patch =&gt; integer(), v =&gt; <a href="#type-version">version()</a>, pre =&gt; <a href="#type-pre">pre()</a>, build =&gt; string(), d =&gt; integer()}
</code></pre>





### <a name="type-pre">pre()</a> ###



<pre><code>
pre() = nil | {<a href="#type-prefix">prefix()</a>, string()}
</code></pre>





### <a name="type-prefix">prefix()</a> ###



<pre><code>
prefix() = alpha | a | beta | b | pre
</code></pre>





### <a name="type-type">type()</a> ###



<pre><code>
type() = major | minor | match
</code></pre>





### <a name="type-version">version()</a> ###



<pre><code>
version() = string()
</code></pre>


<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#bump-2">bump/2</a></td><td></td></tr><tr><td valign="top"><a href="#compare-2">compare/2</a></td><td></td></tr><tr><td valign="top"><a href="#match-2">match/2</a></td><td></td></tr><tr><td valign="top"><a href="#parse-1">parse/1</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="bump-2"></a>

### bump/2 ###


<pre><code>
bump(Type::<a href="#type-type">type()</a>, Version::<a href="#type-version">version()</a>) -&gt; {ok, <a href="#type-version">version()</a>} | {error, any()}
</code></pre>
<br />


<a name="compare-2"></a>

### compare/2 ###


<pre><code>
compare(Version::<a href="#type-version">version()</a>, Expected::<a href="#type-version">version()</a>) -&gt; 0 | -1 | 1 | {error, any()}
</code></pre>
<br />


<a name="match-2"></a>

### match/2 ###


<pre><code>
match(Version::<a href="#type-version">version()</a>, Expected::<a href="#type-expect">expect()</a>) -&gt; true | false
</code></pre>
<br />


<a name="parse-1"></a>

### parse/1 ###


<pre><code>
parse(Version::<a href="#type-version">version()</a>) -&gt; {ok, <a href="#type-parsed_version">parsed_version()</a>} | {error, any()}
</code></pre>
<br />


