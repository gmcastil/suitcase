SHELL 			:= /bin/bash
UNAME 			:= $(shell uname -s)

GITHUB_URL 		:= https://github.com/gmcastil
REPOS 			:= dot-files scripts vimrc

AVNET_URL 		:= https://github.com/Avnet
AVNET_REPO 		:= bdf
DIGILENT_URL 		:= https://github.com/Digilent
DIGILENT_REPO 		:= vivado-boards

AVNET_DIR 		:= $(PWD)/../Avnet
DIGILENT_DIR 		:= $(PWD)/../Digilent

AVNET_REPO_PATH 	:= $(AVNET_DIR)/$(AVNET_REPO)
DIGILENT_REPO_PATH 	:= $(DIGILENT_DIR)/$(DIGILENT_REPO)

SPECIAL_REPOS 		:= $(AVNET_REPO_PATH) $(DIGILENT_REPO_PATH)

GIT_LOCAL_REPOS 	?= $(HOME)/git-local-repos

install: $(REPOS) $(SPECIAL_REPOS)

$(REPOS):
	@git clone "$(GITHUB_URL)/$@" || true
	$(MAKE) -C $@ setup

$(AVNET_REPO_PATH):
	@if [[ "$(UNAME)" == "Linux" && "$(EMBEDDED)" -eq 0 ]]; then \
		mkdir -pv "$(AVNET_DIR)"; \
		git clone "$(AVNET_URL)/$(AVNET_REPO)" "$@"; \
	fi

$(DIGILENT_REPO_PATH):
	@if [[ "$(UNAME)" == "Linux" && "$(EMBEDDED)" -eq 0 ]]; then \
		mkdir -pv "$(DIGILENT_DIR)"; \
		git clone "$(DIGILENT_URL)/$(DIGILENT_REPO)" "$@"; \
	fi

clean:
	@for repo in $(REPOS); do \
		$(MAKE) -C "$$repo" clean; \
	done
	rm -rf $(REPOS)

