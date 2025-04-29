SHELL			:= /bin/bash
UNAME			:= $(shell uname -s)

REPOS			:= dot-files scripts vimrc
GITHUB_URL		:= https://github.com/gmcastil

AVNET_URL		:= https://github.com/Avnet
AVNET_REPO		:= bdf
DIGILENT_URL		:= https://github.com/Digilent
DIGILENT_REPO		:= vivado-boards

GIT_LOCAL_REPOS		?= "$(HOME)/git-local-repos"

.PHONY: install $(REPOS) clean

install: $(REPOS)
	@if [[ "$(UNAME)" == "Linux" && "$(EMBEDDED)" -eq 0 ]]; then \
		mkdir -pv "$(PWD)/../Digilent"; \
		mkdir -pv "$(PWD)/../Avnet"; \
		git clone "$(AVNET_URL)/$(AVNET_REPO)" "$(PWD)/../Avnet/$(AVNET_REPO)"; \
		git clone "$(DIGILENT_URL)/$(DIGILENT_REPO)" "$(PWD)/../Digilent/$(DIGILENT_REPO)"; \
	fi

$(REPOS):
	git clone $(GITHUB_URL)/$@
	$(MAKE) -C $@ setup

clean:
	@for repo in $(REPOS); do \
		$(MAKE) -C $${repo} clean; \
	done
	rm -rf $(REPOS)
