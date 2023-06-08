
include ./makefile-utils/*.mk
.DEFAULT_GOAL := help

# @target bump-major  Bump major version (x)
# @target bump-minor  Bump minor version (y)
# @target bump-patch  Bump patch version (z)
BUMP_TARGETS := $(addprefix bump-,major minor patch)
.PHONY: $(BUMP_TARGETS)
$(BUMP_TARGETS):
	@$(MAKE) $(subst bump-,semver-,$@) > VERSION

# @desc Create or update CHANGELOG.md
.PHONY: changelog
changelog:
	$(MAKE) CHANGELOG NEXT_VERSION=$(shell cat VERSION)
