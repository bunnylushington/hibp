-module(hibp).

-export([ probe/1 ]).

-spec probe(iolist()) -> {ok, hit, integer()}
          | {ok, miss}
          | {error, too_many_results}
          | {error, request_failed}.
probe(PW) ->
  {_Hex, Range, Remainder} = to_sha1(PW),
  check_hibp(Range, Remainder).

%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERNAL FUNCTIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%

to_sha1(Subject) ->
  Hash = crypto:hash(sha, Subject),
  Hex = lists:flatten([io_lib:format("~2.16.0B",[Y]) || <<Y:8>> <= Hash ]),
  {Hex, lists:sublist(Hex, 5), lists:sublist(Hex, 6, 35)}.

check_hibp(Range, Remainder) ->
  case httpc:request(url(Range)) of
    {ok, {{_, 200, _}, _, Body}} ->
      Partials = string:split(Body, "\r\n", all),
      parse(lists:filter(fun(X) -> lists:prefix(Remainder, X) end, Partials));
    _ ->
      {error, request_failed}
  end.

parse([]) ->
  {ok, miss};
parse([Hit]) ->
  [_, Count] = string:split(Hit, ":"),
  {ok, hit, list_to_integer(Count)};
parse(_) ->
  {error, too_many_results}.


url(Range) ->
  "https://api.pwnedpasswords.com/range/" ++ Range.
