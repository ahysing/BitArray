.PHONY: test
test:
	CHPL_TARGET_CPU=native mason test --parallel --show -- -g --specialize --fast

.PHONY: build
build:
	CHPL_TARGET_CPU=native mason build --show --release --force -- --specialize --fast --print-commands --explain-verbose

.PHONY: debug
debug:
	CHPL_TARGET_CPU=native mason build --show --force -- -g --specialize --fast

FUNC :=unsignedAll
.PHONY: print-ir
print-ir:
	CHPL_TARGET_CPU=native mason build --show --force -- --specialize --fast --llvm-print-ir $(FUNC) --llvm-print-ir-stage full

.PHONY: run
run:
	mason run

.PHONY: clean
clean:
	mason clean

.PHONY: clean-docs
clean-docs:
	rm -r docs/

SOURCES = $(wildcard src/*.chpl) $(wildcard src/*/*.chpl)
SOURCES := $(filter-out src/BitArrays/Internal.chpl,$(SOURCES))

INDEX := ./docs/index.html
$(INDEX): $(SOURCES)
	chpldoc $(SOURCES) -o docs/

NOJERKYLL := ./docs/.nojerkyll
$(NOJERKYLL):
	touch $(NOJERKYLL)

docs: $(INDEX) $(NOJERKYLL)
