SHELL		:= /bin/bash
# Submodules containing the actual components we bring with us
REPOS		:= dot-files scripts vimrc

.PHONY: all submodules update setup
.PHONY: $(REPOS)

all: submodules
	$(MAKE) setup

submodules:
	git submodule update --init --recursive

refresh:
	@git pull --recurse-submodules && \
	git submodule update --remote --merge
	@git status
	@printf '%s\n' "If submodules changed, commit with: git add <submodule> && git commit"

setup: $(REPOS)
	@if [[ "$(uname -s)" == "Linux" && $(EMBEDDED) -neq 1 ]]; then \
		./setup_vivado_boards; \
	fi

# Rely on each submodule to contains its own Makefile for installing and setting up
# and then also for cleaning things up.
$(REPOS):
	$(MAKE) -C $@ setup

clean:
	@for repo in $(REPOS); do \
		$(MAKE) -C $${repo} clean; \
	done

