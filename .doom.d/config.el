;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Theme
(setq doom-theme 'doom-one)

(setq doom-font (font-spec :family "Fira Code" :size 12)
      doom-variable-pitch-font (font-spec :family "sans"))

(setq display-line-numbers-type nil)

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

(require 'company)
(setq company-idle-delay 0
      company-minimum-prefix-length 2)

(setq lsp-enable-indentation nil)

;;Latex
;;(setq TeX-save-query nil)
;;(setq latex-run-command "xelatex")
;;(setq TeX-engine "xetex")

;; Org
(setq org-directory "~/Dropbox/Orgzly/")

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

(setq org-pomodoro-long-break-length 30)
(setq org-pomodoro-short-break-length 10)
(setq org-pomodoro-length 60)
