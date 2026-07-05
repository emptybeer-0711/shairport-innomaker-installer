#!/bin/bash

echo "=== AirPi Installer v1.1.0 (PCM5122 + Shairport Sync) ==="

# Update system
sudo apt update
sudo apt upgrade -y

# Install Shairport Sync
sudo apt install -y shairport-sync

echo ">>> Setting correct DAC overlay (PCM5122 / Boss DAC)..."

# Remove only audio-related overlays
sudo sed -i '/allo-boss-dac-pcm512x-audio/d' /boot/firmware/config.txt
sudo sed -i '/hifiberry/d' /boot/firmware/config.txt

# Disable internal audio (cleaner ALSA setup)
sudo sed -i '/dtparam=audio=/d' /boot/firmware/config.txt
echo "dtparam=audio=off" | sudo tee -a /boot/firmware/config.txt

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

echo ">>> Disabling PipeWire & PulseAudio (if present)..."
sudo systemctl disable --now pipewire.service 2>/dev/null || true
sudo systemctl disable --now pipewire-pulse.service 2>/dev/null || true
sudo systemctl disable --now pulseaudio.service 2>/dev/null || true

echo ">>> Improving WiFi responsiveness (minimal power impact)..."
sudo iw dev wlan0 set power_save off

echo ">>> Enabling Shairport Sync..."
sudo systemctl enable shairport-sync

echo ">>> Restarting Shairport Sync..."
sudo systemctl restart shairport-sync

echo "=== Installation complete. Please reboot your Raspberry Pi. ==="
