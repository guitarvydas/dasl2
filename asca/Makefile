devall: testkey testbuiltin testconnections testcomponents testlexical testcode testother teststring testeolcomment testblockcomment testlookup
dev: linenumbers

testmolecule1:
	@echo
	@echo '*** ' testmolecule identity
	#./identity-molecularize.bash <testconnections.asct
	./identity-molecularize.bash <lookup.asct 1>&2
	@echo
	@echo '*** ' molecularize
	#./molecularize.bash <testconnections.asct >/tmp/temp.asct
	./insertlinenumbers.bash <lookup.asct >/tmp/temp.asct
	./rmnl.bash </tmp/temp.asct | ./rmws.bash >/tmp/temp-nowsnl.asct
	wc -l /tmp/temp*.asct

linenumbers:
	@echo
	@echo '*** ' line numbers identity
	./identity-linenumbers.bash <testkey.asct 1>&2
	@echo
	@echo '*** ' line numbers
	./linenumbers.bash <testkey.asct

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

testbuiltin:
	@echo
	@echo '*** ' testbuiltin identity
	./identity-tokenize.bash <testbuiltin.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testbuiltin.asca >testbuilting.asct

testconnections:
	@echo
	@echo '*** ' testconnections identity
	./identity-tokenize.bash <testconnections.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testconnections.asca >testconnections.asct


testlexical:
	@echo
	@echo '*** ' testlexical identity
	./identity-tokenize.bash <testlexical.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testlexical.asca >testlexical.asct

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
