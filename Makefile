GIT_SHA1 = $(shell git rev-parse --verify HEAD)
IMAGES_TAG = ${shell git describe --exact-match --tags 2> /dev/null || echo 'latest'}
IMAGE_PREFIX = ghcr.io/mischief

IMAGE_DIRS = $(shell find . -name Dockerfile -printf '%h\n' | sed 's,^./,,g')
IMAGES = $(foreach imgdir,$(IMAGE_DIRS),$(notdir $(imgdir)))

.PHONY: list
list:
	@echo Available images:
	@echo
	@for f in $(IMAGES); do printf '\t%s\n' $$f; done
	@echo

.PHONY: all
all: $(foreach imgdir,${IMAGE_DIRS},$(notdir $(imgdir)))

.PHONY: push
push: $(patsubst %,%.push,$(foreach imgdir,${IMAGE_DIRS},$(notdir $(imgdir))))

.PHONY: login
login:
	@echo ${GITHUB_TOKEN} | docker login --password-stdin \
		$(dir $(IMAGE_PREFIX)) \
		-u $(notdir $(IMAGE_PREFIX))

define docker-image-target
BASENAME_$(1) = $(notdir $1)
URI_$(1) = $(IMAGE_PREFIX)/$$(BASENAME_$(1))

.PHONY: $$(BASENAME_$(1)) $$(BASENAME_$(1)).push $$(BASENAME_$(1)).push.latest

$$(BASENAME_$1): $1/Dockerfile
	docker build -t $(IMAGE_PREFIX)/$(notdir $1):$(IMAGES_TAG) -t $(IMAGE_PREFIX)/$(notdir $1):latest $1

$$(BASENAME_$1).push: $$(BASENAME_$1).push.latest 

$$(BASENAME_$1).push.latest:
	docker push $$(URI_$1):latest

ifneq ($(IMAGES_TAG),latest)
.PHONY: $$(BASENAME_$1).push.$(IMAGES_TAG)
$$(BASENAME_$1).push: $$(BASENAME_$1).push.$(IMAGES_TAG)
$$(BASENAME_$1).push.$(IMAGES_TAG):
	docker push $$(URI_$1):$(IMAGES_TAG)
endif

endef

$(foreach imgdir,${IMAGE_DIRS},$(eval $(call docker-image-target,$(imgdir))))

# remove builtin rules
.SUFFIXES:

