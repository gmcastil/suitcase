# Submodules containing the actual components we bring with us
REPOS		:= dot-files scripts vimrc

.PHONY: all submodules update 
.PHONY: $(REPOS)

all: submodules $(REPOS)

submodules:
	git submodule update --init --recursive

refresh:
	git pull --recurse-submodules
	git submodule update --remote --merge
	@git status
	@printf '%s\n' "If submodules changed, commit with: git add <submodule> && git commit"

# Rely on each submodule to contains its own Makefile for installing and setting up
# and then also for cleaning things up.
$(REPOS):
	$(MAKE) -C $@

clean:
	@for repo in $(REPOS); do \
		$(MAKE) -C $${repo} clean; \
	done

