# Vsn

Module for parsing and matching versions, follow [SemVer 2.0 schema](http://semver.org/spec/v2.0.0.html).

A version string should normally be a series of numbers separated by periods.

If any part contains letters then that version is considered prerelease. 

Versions with a prerelease part in the Nth part sort less than versions with N-1 parts. 

Prerelease are sorted following this order :

```
alpha = a < beta = b < pre < rc = any()
```

The default prefix is `pre` :

```
1.0-1 = 1.0-pre1
```

Prereleases sort between real releases :

```
1.0 > 1.0.rc > 1.0.pre > 1.0.b > 1.0.a
```

You can also give a build value by adding it at the end, separated
plus (+) :

```
1.0.2-pre1+build1
```

## APIs

### Types

```
version() :: string().
expect() :: string().
type() :: major | minor | match.
prefix() :: alpha | a | beta | b | pre | rc.
pre() ::  nil | {prefix(), string()}.
parsed_version() :: #{major => integer(), 
                      minor => integer(), 
                      patch => integer(), 
                      v => version(), 
                      pre => pre(), 
                      build => string(), 
                      d => integer()}.
```

### bump/2

```
-spec bump(type(), version()) -> {ok, version()} | {error, any()}.
```

### parse/1

```
-spec parse(version()) -> {ok, parsed_version()} | {error, any()}.
```

### max_version/1

```
-spec max_version([version()]) -> version() | {error, any()}.
```

### max_version/2

```
-spec max_version(version(), version()) -> version() | {error, any()}.
```

### max_expected/2

```
-spec max_expected([version()], expect()) -> version() | nil.
```

### min_version/1

```
-spec min_version([version()]) -> version() | {error, any()}.
```

### min_version/2

```
-spec min_version(version(), version()) -> version() | {error, any()}.
```

### min_expected/2

```
-spec min_expected([version()], expect()) -> version() | nil.
```

### next/3

```
-spec next(version(), [version()], stable | unstable) -> version() | nil.
```

## Licence

Copyright (c) 2015, Gregoire Lejeune<br />
Copyright (c) 2016, G-Corp<br />
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
1. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

