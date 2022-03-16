devall: testkey testbuiltin testconnections testlexical testcode testother testlookup
dev: testmolecule

testmolecule:
	@echo
	@echo '*** ' testmolecule identity
	./identity-molecularize.bash <testconnections.asct
	@echo
	@echo '*** ' molecularize
	./molecularize.bash <lookup.asct

testcode:
	@echo
	@echo '*** ' testcode identity
	./identity-tokenize.bash <testcode.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <testcode.asca >testcode.asct

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

testlookup:
	@echo
	@echo '*** ' testlookup identity
	./identity-tokenize.bash <lookup.asca
	@echo
	@echo '*** ' tokenized
	./tokenize.bash <lookup.asca >lookup.asct
