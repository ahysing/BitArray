.PHONY: test
test:
	mason test --parallel --show -- -g --specialize --fast --print-commands --explain-verbose

DEBUGGER := lldb
.PHONY: debug-test
debug-test:
	mason test --no-run --show -- -g --specialize --fast
	./target/test/BitArray32Tests --$(DEBUGGER)
	./target/test/BitArray64Tests --$(DEBUGGER)
	./target/test/InternalTests --$(DEBUGGER)

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


YEAR := $(shell date +'%Y')
./docs/.$(YEAR):
	touch ./docs/.$(YEAR)

INDEX := ./docs/index.html
$(INDEX): $(SOURCES)
	chpldoc $(SOURCES) -o docs/ --author "Andreas Dreyer Hysing"
	find ./docs -name '*.html' -exec sed -i '' 's/ Copyright 2015/ Copyright $(YEAR)/g' {} \;

NOJERKYLL := ./docs/.nojerkyll
$(NOJERKYLL):
	touch $(NOJERKYLL)

docs: $(INDEX) $(NOJERKYLL) ./docs/.$(YEAR)
