.PHONY: build
build:
	mason build --show --release --force -- --vectorize

.PHONY: debug
debug:
	mason build --show -g --force -- --vectorize

.PHONY: run
run:
	mason run

.PHONY: clean
clean:
	mason clean

.PHONY: test
test:
	mason test --show

.PHONY: doc
doc: docs
docs:
	mason doc
	@mv doc docs