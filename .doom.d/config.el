;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Theme
(setq doom-theme 'doom-one)

(setq doom-font (font-spec :family "Fira Code" :size 18)
      doom-variable-pitch-font (font-spec :family "sans"))

(setq display-line-numbers-type 'relative)

;; QoL
(setq which-key-show-early-on-C-h t)
(setq which-key-idle-delay 10000)
(setq which-key-idle-secondary-delay 0.05)
(which-key-mode)

;; C++
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(defconst my-cc-style
  '("stroustrup"
    (c-offsets-alist . ((inline-open . 0)))))
(c-add-style "my-cc-style" my-cc-style)


(after! company
  (setq company-idle-delay 0
        company-minimum-prefix-length 2)
  (setq company-box-doc-delay 0)
  )

(after! corfu
  (setq +corfu-want-minibuffer-completion nil)
  (setq
   corfu-auto 't
   corfu-cycle 't
   corfu-auto-delay 0
   corfu-auto-prefix 2
   corfu-popupinfo-delay '(0 . 0)
   corfu-preview-current nil
   corfu-preselect 'first
   )
  )


(setq lsp-enable-indentation nil)
(setq lsp-inlay-hint-enable 't)
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))

(after! lsp-clangd (set-lsp-priority! 'clangd 2))
;; (add-hook! 'lsp-after-initialize-hook
;;   (flycheck-add-next-checker 'lsp 'c/c++-cppcheck))


;;Latex
;;(setq TeX-save-query nil)
;;(setq latex-run-command "xelatex")
;;(setq TeX-engine "xetex")

;; Org
(after! org
  (setq org-directory "~/Dropbox/Orgzly")
  (setq org-agenda-files (quote ("~/Dropbox/Orgzly" "~/programming_game")))
  (setq org-log-into-drawer t)
  (add-to-list 'org-modules 'org-capture)
  (add-to-list 'org-capture-templates
               '("r" "Reboot" entry
                 (file+olp+datetree "~/Dropbox/Orgzly/Reboot.org")
                 "* %U %?\n%i\n%a"
                 :prepend t))
  (require 'org-habit)
  (require 'org-checklist)
  (setq org-habit-show-habits-only-for-today nil)
  (add-hook 'org-after-todo-state-change-hook 'org-reset-todo-maybe)


  ;; Fix org mode overriding tab key when expanding snippet
  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local yas/trigger-key [tab])
              (define-key yas/keymap [tab] 'yas-next-field-or-maybe-expand)))

  ;; Fix org preventing moving code blocks
  (remove-hook 'org-metaup-hook 'org-babel-load-in-session-maybe)
  (remove-hook 'org-metadown-hook 'org-babel-pop-to-session-maybe)

  ;; Bind M-[] to moving between blocks
  (evil-define-key 'normal 'org-mode-map (kbd "M-[") 'org-babel-previous-src-block)
  (evil-define-key 'normal 'org-mode-map (kbd "M-]") 'org-babel-next-src-block)
  )

(defun org-reset-todo-maybe()
  "Reset subtrees when RESET_CHECK_BOXES is set"
  (interactive)
  (when (member org-state org-done-keywords)
    (if (org-entry-get (point) "RESET_CHECK_BOXES")
        (org-map-tree
         (lambda () (if (string-equal (org-get-todo-state) "[X]")
                        (org-todo "[ ]")))
         )
      )
    )
  )


(defun +org-pomodoro/restart-last-pomodoro ()
  "Starts a new pomodoro on the last clocked-in task.
  Resets the pomodoro count without prompt when necessary.
  This is useful for external scripts as the org-pomodoro
  function has y-or-n prompts"
  (when (and org-pomodoro-last-clock-in
             org-pomodoro-expiry-time
             (org-pomodoro-expires-p))
    (setq org-pomodoro-count 0))
  (setq org-pomodoro-last-clock-in (current-time))

  (call-interactively 'org-clock-in-last)
  (org-pomodoro-start :pomodoro))

(defun +org-pomodoro/start-pomodoro-on-capture ()
  "Starts org-pomodoro upon capture if the pomodoro capture template was used"

  (when (and (not org-note-abort)
             (equal (org-capture-get :pomodoro) t))
    (when (and org-pomodoro-last-clock-in
               org-pomodoro-expiry-time
               (org-pomodoro-expires-p))
      (setq org-pomodoro-count 0))
    (set-buffer (org-capture-get :buffer))
    (goto-char (org-capture-get :insertion-point))
    (org-clock-in)
    (org-pomodoro-start :pomodoro)))

(add-hook 'org-capture-after-finalize-hook #'+org-pomodoro/start-pomodoro-on-capture)

;; Some org-capture-template with :pomodoro t
(setq org-pomodoro-manual-break t)

(setq org-pomodoro-state :none)
(defun org-pomodoro-active-p ()
  "Retrieve whether org-pomodoro is active or not."
  (not (eq org-pomodoro-state :none)))

(setq org-pomodoro-long-break-length 15)
(setq org-pomodoro-short-break-length 10)
(setq org-pomodoro-length 50)

(setq org-pomodoro-finished-sound-args "--volume 8000")
(setq org-pomodoro-overtime-sound-args "--volume 8000")
(setq org-pomodoro-long-break-sound-args "--volume 8000")
(setq org-pomodoro-short-break-sound-args "--volume 8000")


(use-package! ox-moderncv
  :after org)

(after! projectile
  (setq projectile-project-search-path '("~/projects/")))

(after! svg-tag-mode
  (setq svg-tag-tags
        '((":TODO:" . ((lambda (tag) (svg-tag-make "TODO")))))))

;; (use-package! org-roam
;;   :custom
;;   (org-roam-directory (file-truename "~/Dropbox/Orgzly/roam")))

;; (use-package! websocket
;;   :after org-roam)

;; (use-package! org-roam-ui
;;   :after org-roam ;; or :after org
;;   ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;   ;;         a hookable mode anymore, you're advised to pick something yourself
;;   ;;         if you don't care about startup time, use
;;   ;;  :hook (after-init . org-roam-ui-mode)
;;   :config
;;   (setq org-roam-ui-sync-theme t
;;         org-roam-ui-follow t
;;         org-roam-ui-update-on-save t
;;         org-roam-ui-open-on-start t))

;;excersim
(defun exercism(c)
  "Reset subtrees when RESET_CHECK_BOXES is set"
  (interactive "sCommand: ")

  (message c)
  (save-match-data ; is usually a good idea
    ;;exercism download --exercise=hello-world --track=rust
    (string-match "--exercise=\\([^[:space:]]+\\)" c)
    (let ((exercise (match-string 1 c)))
      (string-match "--track=\\([^[:space:]]+\\)" c)
      (let ((track (match-string 1 c)))
        (message "test")
        (shell-command c)
        (+workspace-switch exercise 't)
        (let ((readme (format "~/projects/exercism/%s/%s/README.md" track exercise)))
          (find-file readme)
          )
        (split-window-right)
        (other-window 1)
        (call-interactively #'find-file)))))

(setq dap-auto-configure-mode t)
(require 'dap-cpptools)

(atomic-chrome-start-server)

(defun my/pomodoro-page ()
  "Opens pomodoros info buffer"
  (interactive)
  ;; Create a new buffer
  (let ((buffer (generate-new-buffer "*Custom Buffer*")))
    ;; Insert custom text into the buffer
    (with-current-buffer buffer
      (insert "This is some custom text in the new buffer."))
    ;; Display the buffer in a new window
    (display-buffer buffer)))
