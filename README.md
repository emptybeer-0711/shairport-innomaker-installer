# Shairport-Innomaker Installer

Ein Installationsskript für AirPlay auf dem Raspberry Pi Zero 2W mit dem
InnoMaker DAC Mini (PCM5122).

Dieses Skript:

- aktiviert den korrekten PCM5122 DAC-Treiber (Boss DAC Overlay)
- installiert Shairport Sync
- schreibt eine funktionierende ALSA-Konfiguration
- optimiert die Latenz ohne höheren Stromverbrauch
- deaktiviert unnötige Audio-Dienste (PipeWire/PulseAudio)
- verbessert die WLAN-Reaktionszeit
- startet Shairport Sync automatisch

---

## Installation

Führe einfach diesen Befehl aus:

```bash
curl -sSL https://raw.githubusercontent.com/emptybeer-0711/shairport-innomaker-installer/main/airpi_installer.sh | bash

