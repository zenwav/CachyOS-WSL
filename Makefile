SHARED_DIR := /shared
OPTIONS := v3
TAR_FILES := $(addprefix cachyos-,$(addsuffix -rootfs.wsl, $(OPTIONS)))

all: $(OPTIONS)

$(OPTIONS):
	rm -rf cachyos-$@-rootfs.wsl
	docker run -i --rm --network host --cap-add=SYS_ADMIN -v $(shell pwd):$(SHARED_DIR) -w $(SHARED_DIR) cachyos/cachyos ./scripts/rootfs-gen.sh $@

clean:
	rm -rf $(TAR_FILES)
