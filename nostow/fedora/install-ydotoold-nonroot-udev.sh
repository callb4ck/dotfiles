#!/bin/sh

# Install udev rule to execute ydotoold rootless

echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' > /lib/udev/rules.d/80-ydotooluinput.rules
