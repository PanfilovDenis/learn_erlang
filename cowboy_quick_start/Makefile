compile:
	erlc *.erl

run:
	erl \
	-pa ~/erlang/cowboy/ebin \
	-pa ~/erlang/cowboy/depth/*/ebin \
	-s try_cowboy start

clean:
	-rm *.beam
