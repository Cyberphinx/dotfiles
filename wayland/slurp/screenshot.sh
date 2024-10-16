#!/bin/bash
FILENAME="screenshot-$(date +%F-%T).png"
grim -g "$(slurp)" ~/Pictures/Screenshots/$FILENAME
