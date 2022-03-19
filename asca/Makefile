devall: testkey testbuiltin testconnections testcomponents testlexical testcode testother teststring testeolcomment testblockcomment testother testlookup
old_dev: rmws
dev: tr

target=lookup
tr:
	@echo
	@echo '*** ' tr
	./linenumbers.bash <$(target).asct >/tmp/$(target).asct-lines
	./compoundidents.bash </tmp/$(target).asct-lines >/tmp/$(target).asct-ci
	./trlex.bash </tmp/$(target).asct-ci >/tmp/$(target).asct-lex
	python3 tr.py </tmp/$(target).asct-lex >/tmp/$(target).asc-tr
	./rmws.bash </tmp/$(target).asc-tr >/tmp/$(target).asc-no-ws
	cat /tmp/$(target).asc-no-ws
	wc /tmp/$(target).asct-lines /tmp/$(target).asc-no-ws

compoundidents:
	@echo
	@echo '*** ' compound idents
	./compoundidents.bash <testother.asct


ilinenumbers:
	@echo
	@echo '*** ' line numbers identity
	./identity-linenumbers.bash <testkey.asct 1>&2

linenumbers:
	@echo
	@echo '*** ' line numbers identity
	./identity-linenumbers.bash <testkey.asct 1>&2
	@echo
	@echo '*** ' line numbers
	./linenumbers.bash <testkey.asct

linenumbersbig:
	@echo
	@echo '*** 'big test line numbers identity
	./identity-linenumbers.bash <lookup.asct 1>&2
	@echo
	@echo '*** 'big test line numbers
	./linenumbers.bash <lookup.asct

rmws:
# remove ws tokens...
# but, don't remove ws tokens until multi-token idents have been recognized and taken care of
	@echo
	@echo '*** 'remove whitespace big test line numbers identity
	./identity-linenumbers.bash <lookup.asct 1>&2
	@echo
	@echo '*** 'remove whitespace big test line numbers
	./linenumbers.bash <lookup.asct >/tmp/lookup.asctlines
	./rmws.bash </tmp/lookup.asctlines >/tmp/lookup.ascnows
	cat /tmp/lookup.ascnows
	wc -l /tmp/lookup.asctlines /tmp/lookup.ascnows

testcode:
	@echo
	@echo '*** ' testcode identity
	./identity-tokenize.bash <testcode.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testcode.asca >testcode.asct

teststring:
	@echo
	@echo '*** ' test string identity
	./identity-tokenize.bash <teststring.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <teststring.asca >teststring.asct

testeolcomment:
	@echo
	@echo '*** ' test eolcomment identity
	./identity-tokenize.bash <testeolcomment.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testeolcomment.asca >testeolcomment.asct

testblockcomment:
	@echo
	@echo '*** ' test blockcomment identity
	./identity-tokenize.bash <testblockcomment.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testblockcomment.asca >testblockcomment.asct

testother:
	@echo
	@echo '*** ' testother identity
	./identity-tokenize.bash <testother.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testother.asca >testother.asct

testkey:
	@echo
	@echo '*** ' testkey identity
	./identity-tokenize.bash <testkey.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testkey.asca >testkey.asct
	python3 tr.py <testkey.asct

testbuiltin:
	@echo
	@echo '*** ' testbuiltin identity
	./identity-tokenize.bash <testbuiltin.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testbuiltin.asca >testbuiltin.asct
	python3 tr.py <testbuiltin.asct

testconnections:
	@echo
	@echo '*** ' testconnections identity
	./identity-tokenize.bash <testconnections.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testconnections.asca >testconnections.asct
	python3 tr.py <testconnections.asct

testlexical:
	@echo
	@echo '*** ' testlexical identity
	./identity-tokenize.bash <testlexical.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testlexical.asca >testlexical.asct
	python3 tr.py <testlexical.asct

testcomponents:
	@echo
	@echo '*** ' testcomponents identity
	./identity-tokenize.bash <testcomponents.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testcomponents.asca >testcomponents.asct

testlookup:
	@echo
	@echo '*** ' testlookup identity
	./identity-tokenize.bash <lookup.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <lookup.asca >lookup.asct
