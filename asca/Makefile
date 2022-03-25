dev: tr

#target=devtest
target=lookup

tr:
	@echo
	@echo '*** ' tr
	# convert .asca file into tokens (.asca is "assembler" and .asct is "tokens")
	./tokenize.bash <$(target).asca >/tmp/$(target).asct
	# replace nl tokens with line numbers
	./linenumbers.bash </tmp/$(target).asct >/tmp/$(target).asct-lines
	# convert delimited idents into subidents
	./compoundidents.bash </tmp/$(target).asct-lines >/tmp/$(target).asct-ci
	# make keywords from some idents
	python3 tr.py </tmp/$(target).asct-ci >/tmp/$(target).asc-tr
	# remove whitespace
	./rmws.bash </tmp/$(target).asc-tr >/tmp/$(target).asc-no-ws
	./untokenize.bash </tmp/$(target).asc-no-ws >/tmp/$(target).ascu
	#cat /tmp/$(target).ascu
	./ascal.bash </tmp/$(target).ascu >out.lisp
	cat out.lisp
