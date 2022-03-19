dev: tr

#target=testother
target=lookup

tr:
	@echo
	@echo '*** ' tr
	./linenumbers.bash <$(target).asct >/tmp/$(target).asct-lines
	./compoundidents.bash </tmp/$(target).asct-lines >/tmp/$(target).asct-ci
	python3 tr.py </tmp/$(target).asct-ci >/tmp/$(target).asc-tr
	./rmws.bash </tmp/$(target).asc-tr >/tmp/$(target).asc-no-ws
	cat /tmp/$(target).asc-no-ws
	wc /tmp/$(target).asct-lines /tmp/$(target).asc-no-ws

compoundidents:
	@echo
	@echo '*** ' compound idents
	./compoundidents.bash <testother.asct >/tmp/compoundidents.asct-ci
	python3 tr.py </tmp/compoundidents.asct-ci >/tmp/testother.asct-tr
	cat /tmp/testother.asct-tr


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
