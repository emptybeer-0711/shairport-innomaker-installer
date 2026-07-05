#!/bin/bash

echo "=== AirPi Installer (PCM5122 + Shairport Sync) ==="

# Update system
sudo apt update
sudo apt upgrade -y

# Install Shairport Sync
sudo apt install -y shairport-sync

echo ">>> Setting correct DAC overlay (PCM5122 / Boss DAC)..."

# Remove old overlays
sudo sed -i '/dtoverlay=/d' /boot/firmware/config.txt
sudo sed -i '/dtparam=i2s=/d' /boot/firmware/config.txt

# Add correct overlay
echo "dtparam=i2s=on" | sudo tee -a /boot/firmware/config.txt
echo "dtoverlay=allo-boss-dac-pcm512x-audio" | sudo tee -a /boot/firmware/config.txt

echo ">>> Writing optimized Shairport Sync configuration..."

sudo bash -c 'cat >/etc/shairport-sync.conf <<EOF
alsa =
{
    output_device = "hw:0";
    use_mmap_if_available = "no";
};

latency = 50000;
interpolation = "basic";
EOF'

echo ">>> Disabling PipeWire & PulseAudio (not needed)..."
sudo systemctl disable --now pipewire pipewire-pulse pulseaudio

echo ">>> Improving WiFi responsiveness (minimal power impact)..."
sudo iw dev wlan0 set power_save off

echo ">>> Restarting Shairport Sync..."
sudo systemctl restart shairport-sync

echo "=== Installation complete. Please reboot your Raspberry Pi. ==="
