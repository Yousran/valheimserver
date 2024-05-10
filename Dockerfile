# Menggunakan Ubuntu sebagai base image
FROM steamcmd/steamcmd:latest

# Mengupdate sistem dan menginstall dependensi yang diperlukan
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y software-properties-common wget lib32gcc-s1 lib32stdc++6 screen

# Menambahkan repositori multiverse
RUN add-apt-repository multiverse

# Set direktori home sebagai direktori kerja
WORKDIR /home/steam

# Mendownload dan menginstall Valheim server
RUN steamcmd +login anonymous +force_install_dir /home/steam/valheimserver +app_update 896660 validate +quit

# Expose port yang digunakan Valheim
EXPOSE 2456-2458/udp

# Mengatur environment
ENV PORT=2456 \
    NAME="vinland" \
    WORLD="YourWorldName" \
    PASSWORD="12345" \
    PUBLIC=0

    
VOLUME /home/steam/valheimserver

COPY . /home/steam/valheimserver
# Set direktori server sebagai direktori kerja
WORKDIR /home/steam/valheimserver

# Menjalankan server saat container dijalankan
CMD ["sh", "-c", "./valheim_server.x86_64 -name ${NAME} -port ${PORT} -world ${WORLD} -password ${PASSWORD} -public ${PUBLIC}"]
