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

.PHONY: clean-docs
clean-docs:
	rm -r docs/

.PHONY: test
test:
	mason test --show

SOURCES = $(wildcard src/*.chpl) $(wildcard src/*/*.chpl)
SOURCES := $(filter-out src/BitArrays/Internal.chpl,$(SOURCES))

INDEX := ./docs/index.html
$(INDEX): $(SOURCES)
	chpldoc $(SOURCES) -o docs/

NOJERKYLL := ./docs/.nojerkyll
$(NOJERKYLL):
	touch $(NOJERKYLL)

docs: $(INDEX) $(NOJERKYLL)
