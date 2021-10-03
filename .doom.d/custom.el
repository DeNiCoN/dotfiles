(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-default-style
   '((c-mode . "my-cc-style")
     (c++-mode . "my-cc-style")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "doom")))
 '(org-agenda-files
   '("~/projects/Orgzly/Study.org" "/home/denicon/projects/Orgzly/Organize.org" "/home/denicon/projects/Orgzly/Projects.org_archive" "/home/denicon/projects/Orgzly/Info.org_archive" "/home/denicon/projects/Orgzly/Info.org"))
 '(org-agenda-sticky t)
 '(plantuml-default-exec-mode 'executable)
 '(safe-local-variable-values
   '((projectile-project-configure-cmd . "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=on && cp build compile-commands.json .")
     (flycheck-check-syntax-automatically mode-enabled save idle-change)
     (flycheck-disabled-checkers c/c++-clang c/c++-gcc)
     (projectile-project-compilation-cmd . "cmake --build . -j")
     (projectile-project-compilation-dir . "build")
     (projectile-project-configure-cmd . "cmake -S .. -B . -DCMAKE_EXPORT_COMPILE_COMMANDS=on && cp compile_commands.json .."))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
