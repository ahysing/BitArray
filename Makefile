.PHONY: build
build:
	CHPL_TARGET_CPU=native mason build --show --release --force -- --specialize --fast --print-commands --explain-verbose

.PHONY: debug
debug:
	CHPL_TARGET_CPU=native mason build --show --force -- -g --specialize

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
