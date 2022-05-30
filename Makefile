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

clean-doc:
	rm -r docs/

.PHONY: test
test:
	mason test --show

SOURCES = $(wildcard src/*/*.chpl) $(wildcard test/*/*.chpl)
SOURCES := $(filter-out src/BitArrays/Internal.chpl,$(SOURCES))
.PHONY: doc
doc: docs
docs:
	chpldoc $(SOURCES) -o docs/
	touch docs/.nojekyll