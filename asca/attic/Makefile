dev: tr

#target=testother
target=lookup

tr:
	@echo
	@echo '*** ' tr
	./tokenize.bash <$(target).asca >/tmp/$(target).asct
	./linenumbers.bash <$(target).asct >/tmp/$(target).asct-lines
	./compoundidents.bash </tmp/$(target).asct-lines >/tmp/$(target).asct-ci
	python3 tr.py </tmp/$(target).asct-ci >/tmp/$(target).asc-tr
	./rmws.bash </tmp/$(target).asc-tr >/tmp/$(target).asc-no-ws
	cat /tmp/$(target).asc-no-ws
	wc /tmp/$(target).asct-lines /tmp/$(target).asc-no-ws
