SHELL 			:= /bin/bash
UNAME 			:= $(shell uname -s)

GITHUB_URL 		:= https://github.com/gmcastil
PERSONAL_REPOS 		:= dot-files scripts vimrc

# These just need to be installed
TMUX_PLUGINS_URL	:= http://github.com/tmux-sensible
TMUX_PLUGINS_DIR	:= $(PWD)/../tmux-plugins
TMUX_PLUGINS_REPO	:= tmux-sensible
TMUX_PLUGINS_PATH	:= $(TMUX_PLUGINS_DIR)/$(TMUX_PLUGINS_REPO)

# Group repos that we only need to download by their end location
OTHER_REPOS		:= # $(TMUX_PLUGINS_PATH)

# Embedded boards don't need these, but Linux systems for development that run
# Vivado need board files to be installed, so we pull them down here (the
# Vivado init configuration files will specify these locations as board files
# in the board repo paths)
AVNET_URL 		:= https://github.com/Avnet
AVNET_REPO 		:= bdf
DIGILENT_URL 		:= https://github.com/Digilent
DIGILENT_REPO 		:= vivado-boards

AVNET_DIR 		:= $(PWD)/../Avnet
DIGILENT_DIR 		:= $(PWD)/../Digilent

AVNET_REPO_PATH 	:= $(AVNET_DIR)/$(AVNET_REPO)
DIGILENT_REPO_PATH 	:= $(DIGILENT_DIR)/$(DIGILENT_REPO)

DEVEL_REPOS 		:= $(AVNET_REPO_PATH) $(DIGILENT_REPO_PATH)

# This is where it's expected that configuration repos will all reside
GIT_LOCAL_REPOS 	?= $(HOME)/git-local-repos

install: $(PERSONAL_REPOS) $(DEVEL_REPOS) $(OTHER_REPOS)

refresh:
	@for repo in $(PERSONAL_REPOS); do \
		$(MAKE) -C "$${repo}" setup; \
	done

$(PERSONAL_REPOS):
	@git clone "$(GITHUB_URL)/$@" || true
	$(MAKE) -C $@ setup

$(TMUX_PLUGINS_PATH):
	@mkdir -pv "$(TMUX_PLUGINS_DIR)" && \
	git clone "$(TMUX_PLUGINS_URL)/$(TMUX_PLUGINS_REPO)" "$@"

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
	@for repo in $(PERSONAL_REPOS); do \
		$(MAKE) -C "$$repo" clean; \
	done

