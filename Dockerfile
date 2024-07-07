FROM debian:stable AS builder

RUN apt-get update && apt-get install -y \
    xorriso \
    aria2 \
    squashfs-tools \
    && rm -rf /var/lib/apt/lists/*

RUN aria2c https://www.mathlibre.org/pub/mathlibre/mathlibre-debian-amd64-20220402-ja.iso --checksum=md5=629e9be76cdd2726a47fb650ec1389a3

RUN mkdir rootfs unsquashfs \
    && osirrox -indev mathlibre-debian-amd64-20220402-ja.iso -extract / rootfs \
    && unsquashfs -force -dest unsquashfs rootfs/live/filesystem.squashfs


FROM scratch

COPY --from=builder /unsquashfs /

CMD ["/bin/bash"]
