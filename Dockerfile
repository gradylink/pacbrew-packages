FROM alpine:latest

RUN apk add pacman git build-base wget

# PacBew Official Packages
RUN echo "[pacbrew]" >> /etc/pacman.conf \
  && echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf \
  && echo "Server = https://pacman.mydedibox.fr/pacbrew/packages/" >> /etc/pacman.conf \
  && pacman -Sy --noconfirm ps4-openorbis ps4-openorbis-portlibs

# Our Patched Packages
RUN pacman -U --noconfirm https://github.com/gradylink/pacbrew-packages/releases/download/sdl2_image-2.6.3-1/ps4-openorbis-sdl2_image-2.6.3-1-any.pkg.tar.zst && pacman -U --noconfirm https://github.com/gradylink/pacbrew-packages/releases/download/sdl2_image-2.6.3-1/ps4-openorbis-libcurl-8.4.0-1-any.pkg.tar.gz && pacman -U --noconfirm https://github.com/gradylink/pacbrew-packages/releases/download/sdl2_image-2.6.3-1/ps4-openorbis-sdl2_gfx-1.0.4-1-any.pkg.tar.gz

# Environment Variables
ENV PACBREW=/opt/pacbrew
ENV OO_PS4_TOOLCHAIN=/opt/pacbrew/ps4/openorbis
