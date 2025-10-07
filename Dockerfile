FROM archlinux:latest

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git wget base-devel unzip tar clang lld

# PacBew Official Packages
RUN echo "[pacbrew]" >> /etc/pacman.conf \
  && echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf \
  && echo "Server = https://pacman.mydedibox.fr/pacbrew/packages/" >> /etc/pacman.conf \
  && pacman -Sy --noconfirm ps4-openorbis ps4-openorbis-portlibs

# Our Patched Packages
RUN wget https://github.com/gradylink/pacbrew-packages/releases/download/sdl2_image-2.6.3-1/ps4-openorbis-sdl2_image-2.6.3-1-any.pkg.tar.zst && wget https://github.com/gradylink/pacbrew-packages/releases/download/sdl2_image-2.6.3-1/ps4-openorbis-libcurl-8.4.0-1-any.pkg.tar.gz && wget https://github.com/gradylink/pacbrew-packages/releases/download/sdl2_image-2.6.3-1/ps4-openorbis-sdl2_gfx-1.0.4-1-any.pkg.tar.gz \
  && pacman -U --noconfirm ps4-openorbis-sdl2_image-2.6.3-1-any.pkg.tar.zst ps4-openorbis-libcurl-8.4.0-1-any.pkg.tar.gz ps4-openorbis-sdl2_gfx-1.0.4-1-any.pkg.tar.gz \
  && rm ps4-openorbis-sdl2_image-2.6.3-1-any.pkg.tar.zst ps4-openorbis-libcurl-8.4.0-1-any.pkg.tar.gz ps4-openorbis-sdl2_gfx-1.0.4-1-any.pkg.tar.gz

# Official OpenOrbis (PacBrew one has some issues)
RUN wget https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain/releases/download/v0.5.3/toolchain-llvm-18.2.zip && unzip toolchain-llvm-18.2.zip && tar xf toolchain-llvm-18.tar.gz && mv OpenOrbis/PS4Toolchain /opt/openorbis && rm -r OpenOrbis toolchain-llvm-18.tar.gz toolchain-llvm-18.2.zip

# Remove OpenOrbis Portlibs to prevent PacBrew Conflicts
RUN rm /opt/openorbis/lib/libSDL2.a /opt/openorbis/lib/libSDL2main.a /opt/openorbis/lib/libSDL2_image.a

# Environment Variables
ENV PACBREW=/opt/pacbrew
ENV OO_PS4_TOOLCHAIN=/opt/openorbis
