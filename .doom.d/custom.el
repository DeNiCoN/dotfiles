;;; custom.el -*- lexical-binding: t; -*-


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
 '(org-agenda-sticky t)
 '(plantuml-default-exec-mode 'executable)
 '(safe-local-variable-values
   '((org-attach-id-dir . ".attach/")
     (org-attach-directory . ".attach/")))
 '(warning-suppress-types '((revert-buffer-internal-hook))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
