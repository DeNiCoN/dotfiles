#!/usr/bin/env bash
amixer get Capture | grep '\[off\]' && echo "%{F#f00}%{F-}" || echo "%{F#0f0}%{F-}"
