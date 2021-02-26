hibp
=====

A trivial function to check a plaintext password against the database
maintained at https://haveibeenpwned.com

One function is exported:

``` erlang
hibp:probe("password").
```

Results will be one of:

``` erlang
{ok, hit, hit_count_integer}
{ok, miss}
{error, too_many_results}
{error, request_failed}
```

Acknowledgement
---------------

This library uses the haveibeenpwned.com HTTPS interface.  The data
returned are provided by haveibeenpawned.com.

Author
------

Bunny Lushington
<bunny@bapi.us>
