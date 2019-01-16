;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;; Code:
(package-initialize)

;; Define XDG directories
(setq-default user-emacs-config-directory
              (concat (getenv "HOME") "/.config/emacs"))
(setq-default user-emacs-data-directory
              (concat (getenv "HOME") "/.local/share/emacs"))
(setq-default user-emacs-cache-directory
              (concat (getenv "HOME") "/.cache/emacs"))

;; Increase the threshold to reduce the amount of garbage collections made
;; during startups.
(setq gc-cons-threshold (* 50 1000 1000))
;; And reset it to make gc pauses shorter once everything is up and running
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))))

;; Unless the =$XGD_DATA_DIR/emacs/backup= directory exists, create it. Then set as backup directory.
(let ((backup-dir (concat user-emacs-data-directory "/backup")))
  (unless (file-directory-p backup-dir)
    (mkdir backup-dir t))
  (setq-default backup-directory-alist (cons (cons "." backup-dir) nil)))

;; helm
(use-package helm
  :defer 2
  :diminish helm-mode
  :bind (("C-x C-f" . helm-find-files)
         ("M-x" . helm-M-x)
         ("C-x b" . helm-mini)
         ("C-x C-b" . helm-mini)
         ("M-y" . helm-show-kill-ring)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action) ; Rebind TAB to expand
         ("C-i" . helm-execute-persistent-action) ; Make TAB work in CLI
         ("C-z" . helm-select-action)) ; List actions using C-z
  :config
  (progn
    (setq helm-buffer-max-length nil) ;; Size according to longest buffer name
    (setq helm-split-window-in-side-p t)
    (helm-mode 1)))

(use-package helm-fuzzier
  :defer 2
  :config
  (progn
    (setq helm-mode-fuzzy-match t
          helm-M-x-fuzzy-match t
          helm-buffers-fuzzy-match t
          helm-recentf-fuzzy-match t)
    (helm-fuzzier-mode 1)))

(use-package helm-ag)
(use-package helm-pass)
(use-package helm-projectile)

;; Remove suspend keys (annoying at best)
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;; Disable creation of lock-files named .#<filename>.
(setq-default create-lockfiles nil)

;; Theme
(add-to-list 'default-frame-alist '(font . "Inconsolata 12"))
(use-package zerodark-theme
  :config
  (progn
    (load-theme 'zerodark t)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
    (zerodark-setup-modeline-format)))

;; Load .envrc from emacs
(use-package direnv
  :defer 1
  :config
  (direnv-mode))

;; Basic code-style
(setq c-basic-indent 4)
(setq indent-line-function 'insert-tab)
(setq indent-tabs-mode nil)
(setq tab-stop-list '(4 8 12 16 20 24 28 32))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Python autocomplete
(use-package jedi
  :defer 1
  :config
  (progn
    (add-hook 'python-mode-hook 'jedi:setup)
    (setq-default jedi:setup-keys t)
    (setq-default jedi:complete-on-dot t)))

(use-package go-mode
  :defer 1
  :config
  (progn
    (add-hook 'go-mode-hook
              (lambda ()
                (unless (executable-find "gocode")
                  (error "Program: gocode is missing"))
                (set (make-local-variable 'company-backends) '(company-go))
                (company-mode t)))
    (add-hook 'before-save-hook 'gofmt-before-save)))

;; Multi-mode web file editing
(use-package web-mode
  :defer 2
  :mode "\\.twig$"
  :mode "\\.html$"
  :config
  (progn
    (setq web-mode-markup-indent-offset 4) ; HTML
    (setq web-mode-css-indent-offset 4)    ; CSS
    (setq web-mode-code-indent-offset 4))) ; JS/PHP/etc

;; Nix
(use-package nix-mode
  :defer 2
  :mode "\\.nix$"
  :config (setq nix-indent-function 'nix-indent-line))

;; Better js mode
(use-package xref-js2)
(use-package ac-js2)
(use-package js2-mode
  :defer 1
  :config
  (progn
    (add-hook 'js2-mode-hook 'ac-js2-mode)
    (setq js2-strict-missing-semi-warning nil)
    (setq js2-strict-trailing-comma-warning nil)
    (setq js-indent-mode 2)
    (add-hook 'js2-mode-hook 'ac-js2-setup-auto-complete-mode)
    (define-key js2-mode-map (kbd "M-.") nil)
    (add-hook 'js2-mode-hook (lambda ()
      (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; JS debugger
(use-package mocha)
(use-package indium
  :defer 1
  :config
  (progn
    (add-hook 'js-mode-hook #'indium-interaction-mode)
    (setq mocha-debugger 'indium)))

;; Global magit keys
(use-package magit
  :config
  (progn
    (global-set-key (kbd "C-x g") 'magit-status) ; Display the main magit popup
    (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup) ; Display keybinds for magit
    ))

;; Autocomplete
(use-package company)
(use-package company-flx)
(use-package company-statistics)
(use-package company-go)

(progn
  (setq-default company-tooltip-minimum-width 15)
    (setq-default company-idle-delay 0.1)
    (global-company-mode))
(progn
  (with-eval-after-load 'company
    (company-flx-mode +1)))
(progn
  (setq-default company-statistics-file
                (concat user-emacs-data-directory
                        "/company-statistics.dat"))
  (company-statistics-mode))

;; Smooth-scroll
(use-package smooth-scrolling
  :config
  (progn
    (setq-default smooth-scroll-margin 2)))

;; Fancy search
(use-package swiper-helm
  :config
  (progn
    (global-set-key (kbd "C-s") 'swiper-helm)
    (global-set-key (kbd "C-r") 'swiper-helm)))
(use-package helm-rg)

;; Global webpaste shortcuts
(use-package webpaste
  :defer 1
  :config
  (progn
    (global-set-key (kbd "C-c C-p C-b") 'webpaste-paste-buffer)
    (global-set-key (kbd "C-c C-p C-r") 'webpaste-paste-region)))

;; Smart mode line
(use-package smart-mode-line-powerline-theme)
(use-package smart-mode-line
  :config
  (progn
    (setq sml/theme 'powerline)
    (setq sml/no-confirm-load-theme t)
    (sml/setup)))

;; Always attempt flycheck
(use-package flycheck
  :config (global-flycheck-mode))
(use-package flycheck-irony)
(use-package flycheck-mypy)
(use-package flycheck-rust)
(use-package flycheck-elixir)

;; Smart parens
(use-package smartparens
  :config
  (progn
    (add-hook 'js-mode-hook #'smartparens-mode)
    (add-hook 'html-mode-hook #'smartparens-mode)
    (add-hook 'python-mode-hook #'smartparens-mode)
    (add-hook 'lua-mode-hook #'smartparens-mode)
    (add-hook 'ruby-mode-hook #'smartparens-mode)
    (add-hook 'rust-mode-hook #'smartparens-mode)))

;; Org-exports
(use-package org)
(use-package ox-gfm
  :config
  (progn
    (eval-after-load "org"
      '(require 'ox-gfm nil t))
    ;; Syntax highlight in babel exports (has extra env requirements)
    (require 'ox-beamer)
    (require 'ox-latex)
    (setq org-export-allow-bind-keywords t)
    (setq org-latex-listings 'minted)
    (add-to-list 'org-latex-packages-alist '("" "minted" "listings"))
    (setq org-latex-pdf-process
          '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))))


(use-package exwm
  :config
  (progn
    (require 'exwm)
    (require 'exwm-randr)
    (require 'dbus)

    (defun pnh-run (command)
      (interactive (list (read-shell-command "$ ")))
      (let (
            (cmd (concat
                  "systemd-run --user "
                  command)))
        (start-process-shell-command cmd nil cmd)))
    (define-key exwm-mode-map (kbd "s-!") 'pnh-run)
    (global-set-key (kbd "s-!") 'pnh-run)

    (add-hook 'exwm-update-class-hook
              (lambda ()
                (exwm-workspace-rename-buffer exwm-class-name)))

    ;; Note: This approach does not work with Emacs 25 due to a bug of Emacs.
    (add-hook 'exwm-manage-finish-hook
              (lambda ()
                (when (and exwm-class-name
                           (string= exwm-class-name "URxvt"))
                  (exwm-input-set-local-simulation-keys '(([?\C-c ?\C-c] . ?\C-c))))))

    (add-hook 'exwm-update-title-hook
              (lambda ()
                (let ((tilde-exwm-title
                       (replace-regexp-in-string (getenv "HOME") "~" exwm-title)))
                  (exwm-workspace-rename-buffer (format "%s: %s" exwm-class-name tilde-exwm-title)))))

    ;; Display time in modeline
    (progn
      (setq display-time-24hr-format t)
      (display-time-mode 1))

    ;; Battery is useful too
    (display-battery-mode)

    (require 'exwm-systemtray)
    (exwm-systemtray-enable)
    (setq exwm-systemtray-height 16)

    (setq exwm-manage-configurations
          '(((equal exwm-class-name "Firefox Developer Edition")
             simulation-keys (([?\C-q] . [?\C-w])  ; close tab instead of quitting Firefox
                              ([?\C-b] . [left])
                              ([?\C-f] . [right])
                              ([?\C-p] . [up])
                              ([?\C-n] . [down])
                              ([?\C-t] . [?\C-n])
                              ([?\C-s] . [?\C-f])
                              ([?\C-a] . [home])
                              ([?\C-e] . [end])
                              ([?\M-v] . [prior])
                              ([?\C-v] . [next])
                              ([?\C-d] . [delete])))
            ))

    (exwm-input-set-simulation-keys
     (mapcar (lambda (c) (cons (kbd (car c)) (cdr c)))
             `(("C-b" . left)
               ("C-f" . right)
               ("C-p" . up)
               ("C-n" . down)
               ("C-a" . home)
               ("C-e" . end)
               ("M-v" . prior)
               ("C-v" . next)
               ("C-d" . delete)
               ("C-m" . return)
               ("C-i" . tab)
               ("C-g" . escape)
               ("C-s" . ?\C-f)
               ("C-y" . ?\C-v)
               ("M-w" . ?\C-c)
               ("M-<" . C-home)
               ("M->" . C-end)
               ("C-M-h" . C-backspace))))

    (exwm-input-set-key
     (kbd "s-g")
     (defun pnh-ff-gsearch ()
       (interactive)
       (browse-url
        (format "https://google.com/search?q=%s"
                (read-string "Terms: ")))))

    (exwm-input-set-key
     (kbd "s-s")
     (defun pnh-ff-url ()
       (interactive)
       (browse-url
        (read-string "URL: "))))

    (exwm-input-set-key
     (kbd "s-t")
     (defun pnh-terminal ()
       (interactive)
       (let ((cmd "systemd-run --user urxvt"))
         (start-process-shell-command cmd nil cmd))))

    (setq browse-url-firefox-arguments '("-new-window"))
    (setq exwm-randr-workspace-output-plist '(1 "DP-2-2"))
    (require 'exwm-config)
    (exwm-config-default)
    (exwm-randr-enable)
    (exwm-enable)
    (server-start)))

(winner-mode 1)

(use-package exwm-edit
  :config
  (add-hook
   'exwm-edit-compose-hook
   (lambda () (set-input-method "swedish-postfix"))))

(use-package exim
  :config
  (progn
    (push ?\C-\\ exwm-input-prefix-keys)
    (add-hook 'exwm-init-hook 'exim-start)))

(use-package desktop-environment
  :config
  (progn
    (require 'desktop-environment)
    (desktop-environment-mode)
    (setq desktop-environment-brightness-set-command "light %s")
    (setq desktop-environment-brightness-normal-decrement "-U 10")
    (setq desktop-environment-brightness-small-decrement "-U 5")
    (setq desktop-environment-brightness-normal-increment "-A 10")
    (setq desktop-environment-brightness-small-increment "-A 5")
    (setq desktop-environment-brightness-get-command "light")
    (setq desktop-environment-brightness-get-regexp "\\([0-9]+\\)\\.[0-9]+")
    (setq desktop-environment-screenlock-command "loginctl lock-session")
    (setq desktop-environment-screenshot-command "flameshot gui")))

;; PDF support
(use-package pdf-tools
    :config
    (pdf-tools-install)
    ;; Pdf and swiper does not work together
    (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward-regexp)
    )

(use-package weechat
  :config
  (progn
    (require 'weechat-notifications)
    (defun weechat-activate ()
      (interactive)
      (weechat-connect "localhost" 9000 "supersecret" 'plain))
    (add-hook 'weechat-mode-hook
              (lambda () (set-input-method "swedish-postfix")))
    (add-hook 'weechat-connect-hook
              (lambda () (weechat-monitor-all-buffers)))))

;; Various modes
(use-package vterm :defer 1)
(use-package pass)
(use-package fish-mode)
(use-package jinja2-mode)
(use-package lua-mode)
(use-package rust-mode)
(use-package android-mode)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package elixir-mode)
(use-package ag)
(use-package swift-mode)
(use-package protobuf-mode)
(use-package terraform-mode)
(use-package kdeconnect)
(use-package dumb-jump)
(use-package handlebars-mode)
(use-package dockerfile-mode)
(use-package deadgrep)
(use-package groovy-mode)
(use-package cider)

(use-package 2048-game)

(defvar multiple-cursors-keymap (make-sparse-keymap))
(use-package multiple-cursors
  :bind-keymap ("C-t" . multiple-cursors-keymap)
  :bind (:map multiple-cursors-keymap
              ("C-s" . mc--mark-symbol-at-point)
              ("C-w" . mark-word)
              ("C-n" . mc/mark-next-like-this)
              ("C-p" . mc/mark-previous-like-this)
              ("n" . mc/mark-next-like-this-symbol)
              ("p" . mc/mark-previous-like-this-symbol)
              ("C-a" . 'mc/mark-all-like-this)))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package which-key
  :config
  (progn
    (which-key-mode)))

(use-package transmission
  :bind (:map transmission-mode-map
              ("k" . transmission-remove)))

(use-package aggressive-indent)
  ;; :config
  ;; (progn
  ;;   (global-aggressive-indent-mode 1)
  ;;   (add-hook 'helm-minibuffer-set-up-hook
  ;;             (lambda () (global-aggressive-indent-mode 0)))
  ;;   (add-hook 'helm-cleanup-hook
  ;;             (lambda () (global-aggressive-indent-mode 1)))))

(use-package highlight-parentheses
  :config
  (global-highlight-parentheses-mode))

;; Rebind O to open files in external applications
(define-key dired-mode-map (kbd "O")
  (lambda ()
    (interactive)
    (let (
          (cmd (concat
                "xdg-open "
                (dired-file-name-at-point))))
      (start-process-shell-command cmd nil cmd))))
