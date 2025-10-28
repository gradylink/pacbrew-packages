FROM archlinux:latest

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git wget base-devel unzip tar clang lld openssl-1.1 go

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
RUN wget https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain/releases/download/v0.5.2/v0.5.2.tar.gz && tar xf v0.5.2.tar.gz && mv OpenOrbis/PS4Toolchain /opt/openorbis && rm v0.5.2.tar.gz

# Remove OpenOrbis Portlibs to prevent PacBrew Conflicts
RUN rm /opt/openorbis/lib/libSDL2.a /opt/openorbis/lib/libSDL2main.a /opt/openorbis/lib/libSDL2_image.a

# Newer create-gp4
RUN git clone https://github.com/OpenOrbis/create-gp4.git && cd create-gp4/cmd/create-gp4 && go build -o /opt/openorbis/bin/linux/create-gp4 && cd / && rm -r create-gp4

# Environment Variables
ENV PACBREW=/opt/pacbrew
ENV OO_PS4_TOOLCHAIN=/opt/openorbis
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
