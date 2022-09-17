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
TAG_$(1) = $(shell cat $1/TAG 2>/dev/null || echo)

.PHONY: $$(BASENAME_$(1)) $$(BASENAME_$(1)).push $$(BASENAME_$(1)).push.latest $$(BASENAME_$(1).push.$$(TAG_$(1))

$$(BASENAME_$1): $1/Dockerfile
	docker build \
		-t $(IMAGE_PREFIX)/$(notdir $1):latest \
		$1
ifneq (,$$(TAG_$1))
	docker tag $(IMAGE_PREFIX)/$(notdir $1):latest \
		$(IMAGE_PREFIX)/$(notdir $1):$$(TAG_$1)
endif

$$(BASENAME_$1).push: $$(BASENAME_$1).push.latest 

$$(BASENAME_$1).push.latest:
	docker push $$(URI_$1):latest

ifneq (,$$(TAG_$1))
$$(BASENAME_$1).push: $$(BASENAME_$1).push.$$(TAG_$1)
$$(BASENAME_$1).push.$$(TAG_$1):
	docker push $$(URI_$1):$$(TAG_$1)
endif

endef

$(foreach imgdir,${IMAGE_DIRS},$(eval $(call docker-image-target,$(imgdir))))

# remove builtin rules
.SUFFIXES:

