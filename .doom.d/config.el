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
        company-minimum-prefix-length 2))


(setq lsp-enable-indentation nil)
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))

(after! lsp-clangd (set-lsp-priority! 'clangd 2))
(add-hook! 'lsp-after-initialize-hook
  (flycheck-add-next-checker 'lsp 'c/c++-cppcheck))


;;Latex
;;(setq TeX-save-query nil)
;;(setq latex-run-command "xelatex")
;;(setq TeX-engine "xetex")

;; Org
(after! org
  (setq org-directory "~/Dropbox/Orgzly")
  (setq org-agenda-files (quote ("~/Dropbox/Orgzly")))
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


(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))

(defun +org-pomodoro/restart-last-pomodoro ()
  "Starts a new pomodoro on the last clocked-in task. Resets the pomodoro count without prompt when necessary.
  This is useful for external scripts as the org-pomodoro function has y-or-n prompts"
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

(setq org-pomodoro-long-break-length 10)
(setq org-pomodoro-short-break-length 10)
(setq org-pomodoro-length 60)

(use-package! ox-moderncv
  :after org)

(after! projectile
  (setq projectile-project-search-path '("~/projects/")))

(after! svg-tag-mode
  (setq svg-tag-tags
        '((":TODO:" . ((lambda (tag) (svg-tag-make "TODO")))))))

