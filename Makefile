SHELL		:= /bin/bash
UNAME		:= $(shell uname -s)

REPOS		:= dot-files scripts vimrc
GITHUB_URL	:= https://github.com/gmcastil

.PHONY: install $(REPOS) clean

install: $(REPOS)
	echo hello
	@if [[ "$(UNAME)" == "Linux" && $(EMBEDDED) -eq 0 ]]; then \
		./setup_vivado_boards; \
	fi

$(REPOS):
	git clone $(GITHUB_URL)/$@
	$(MAKE) -C $@ setup

clean:
	@for repo in $(REPOS); do \
		$(MAKE) -C $${repo} clean; \
	done
	rm -rf $(REPOS)
