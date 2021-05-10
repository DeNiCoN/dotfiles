#!/usr/bin/env bash
emacsclient -c --eval "(progn (org-todo-list)(split-window-horizontally)(org-agenda-list))"
