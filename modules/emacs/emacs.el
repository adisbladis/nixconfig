(setq comp-deferred-compilation nil)

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
(let ((gc-cons-threshold (* 50 1000 1000))
      (gc-cons-percentage 0.6)
      (file-name-handler-alist nil)))

;; Display emojis in Emacs
(setf use-default-font-for-symbols nil)
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)

;; Remove suspend keys (annoying at best)
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;; Use pass for authentication
(auth-source-pass-enable)

;; Disable creation of lock-files named .#<filename>.
(setq-default create-lockfiles nil)

;; Unless the =$XGD_DATA_DIR/emacs/backup= directory exists, create it. Then set as backup directory.
(let ((backup-dir (concat user-emacs-data-directory "/backup")))
  (unless (file-directory-p backup-dir)
    (mkdir backup-dir t))
  (setq-default backup-directory-alist (cons (cons "." backup-dir) nil)))

;; Flycheck
(use-package flycheck
  :config (global-flycheck-mode))
(use-package flycheck-mypy)
(use-package flycheck-rust)
(use-package flycheck-elixir)

(add-to-list 'default-frame-alist '(font . "Inconsolata 8"))
(use-package nothing-theme)
(use-package zerodark-theme
  :config
  (progn
    (load-theme 'zerodark t)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (blink-cursor-mode -1)
    (scroll-bar-mode -1)
    (zerodark-setup-modeline-format)))

;; Smooth-scroll
(use-package smooth-scrolling
  :config
  (progn
    (setq-default smooth-scroll-margin 2)))

(use-package vterm
  :defer 1
  :config
  (progn
    (setq vterm-max-scrollback 100000)
    (setq vterm-buffer-name-string "vterm %s")))

(use-package exwm
  :config
  (progn
    (require 'xcb)
    (require 'exwm)

    (setq exwm-layout-show-all-buffers t)
    (setq exwm-workspace-show-all-buffers t)

    (require 'exwm-randr)
    (exwm-randr-enable)

    (require 'exwm-systemtray)
    (setq exwm-systemtray-height 16)
    (exwm-systemtray-enable)

    (require 'exwm-config)
    (exwm-config-example)

    ;; Enable input method
    (require 'exwm-xim)
    (exwm-xim-enable)
    (push ?\C-\\ exwm-input-prefix-keys)

    (use-package exwm-edit
      :config
      (add-hook
       'exwm-edit-compose-hook
       (lambda () (set-input-method "swedish-postfix"))))

    (defun adis-run (command)
      (interactive (list (read-shell-command "$ ")))
      (let (
            (cmd (concat
                  "systemd-run --user "
                  command)))
        (start-process-shell-command cmd nil cmd)))
    (define-key exwm-mode-map (kbd "s-!") 'adis-run)
    (global-set-key (kbd "s-!") 'adis-run)

    (add-hook 'exwm-update-class-hook
              (lambda ()
                (exwm-workspace-rename-buffer exwm-class-name)))

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

    (use-package desktop-environment
      :config
      (progn
        (require 'desktop-environment)
        (desktop-environment-mode)
        (setq desktop-environment-volume-normal-increment "1%+")
        (setq desktop-environment-volume-normal-decrement "1%-")
        (setq desktop-environment-brightness-set-command "light %s")
        (setq desktop-environment-brightness-normal-decrement "-U 10")
        (setq desktop-environment-brightness-small-decrement "-U 5")
        (setq desktop-environment-brightness-normal-increment "-A 10")
        (setq desktop-environment-brightness-small-increment "-A 5")
        (setq desktop-environment-brightness-get-command "light")
        (setq desktop-environment-brightness-get-regexp "\\([0-9]+\\)\\.[0-9]+")
        (setq desktop-environment-screenlock-command "loginctl lock-session")
        (setq desktop-environment-screenshot-command "flameshot gui")))

    ;; Mouse follows focus for exwm
    (use-package exwm-mff
      :config
      (progn
        (exwm-mff-mode)))

    (exwm-input-set-key
     (kbd "s-t")
     (defun adis-terminal ()
       (interactive)
       (vterm "vterm*")))

    (exwm-input-set-key
     (kbd "s-o")
     'ace-window)

    (setq exwm-manage-configurations
          '(((equal exwm-class-name "Firefox")
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

    (setq browse-url-firefox-arguments '("-new-window"))

    (server-start)

    ))

;; Smart mode line
(use-package smart-mode-line-powerline-theme)
(use-package smart-mode-line
  :config
  (progn
    (setq sml/theme 'powerline)
    (setq sml/no-confirm-load-theme t)
    (sml/setup)))

;; Show which key triggers what command
(use-package which-key
  :config
  (progn
    (which-key-mode)))

;; Window switcher
(use-package ace-window
  :config
  (progn
    (ace-window-display-mode)))

;; Window management undo/redo
(winner-mode 1)

;; Basic code-style
(setq c-basic-indent 4)
(setq indent-line-function 'insert-tab)
(setq indent-tabs-mode nil)
(setq tab-stop-list '(4 8 12 16 20 24 28 32))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Debugging
(use-package realgud)

;; Go
(use-package go-mode
  :defer 1
  :config
  (progn
    (add-hook 'before-save-hook 'gofmt-before-save)))

;; Nix
(use-package nix-mode
  :defer 2
  :mode "\\.nix$"
  :config (setq nix-indent-function 'nix-indent-line))

;; Global magit keys
(use-package magit
  :config
  (progn
    (global-set-key (kbd "C-x g") 'magit-status) ; Display the main magit popup
    (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup) ; Display keybinds for magit
    ))

;; PDF support
(use-package pdf-tools
    :config
    (pdf-tools-install)
    ;; Pdf and swiper does not work together
    (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward-regexp)
    )

(use-package highlight-parentheses
  :config
  (global-highlight-parentheses-mode))

;; Rust
(use-package rust-mode)
(use-package cargo)

;; Matrix client
(use-package ement
  :config
  (progn
    (require 'ement-room-list)
    (defun matrix-connect ()
      (interactive)
      (ement-connect
       :uri-prefix "http://localhost:8008"
       :user-id "@adis:blad.is"
       :password (replace-regexp-in-string "\n$" "" (auth-source-pass--read-entry "matrix.blad.is/adis"))
       ))))

;; Various modes
(use-package fish-mode)
(use-package jinja2-mode)
(use-package android-mode)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package elixir-mode)
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
(use-package bazel)
(use-package lua-mode)
(use-package capnp-mode)

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

;; ;; Autocomplete
(use-package company
  :config
  (progn
  (setq-default company-tooltip-minimum-width 15)
    (setq-default company-idle-delay 0.1)
    (use-package company-flx)
    (use-package company-statistics)
    (progn
      (with-eval-after-load 'company
        (company-flx-mode +1)))
    (progn
      (setq-default company-statistics-file
                    (concat user-emacs-data-directory
                            "/company-statistics.dat"))
      (company-statistics-mode))
    (use-package company-go)
    (global-company-mode)))

;; Global webpaste shortcuts
(use-package webpaste
  :defer 1
  :config
  (progn
    (global-set-key (kbd "C-c C-p C-b") 'webpaste-paste-buffer)
    (global-set-key (kbd "C-c C-p C-r") 'webpaste-paste-region)))

;; Smart parens
(use-package smartparens
  :config
  (progn
    (add-hook 'js-mode-hook #'smartparens-mode)
    (add-hook 'html-mode-hook #'smartparens-mode)
    (add-hook 'python-mode-hook #'smartparens-mode)
    (add-hook 'lua-mode-hook #'smartparens-mode)
    (add-hook 'rust-mode-hook #'smartparens-mode)
    (add-hook 'ruby-mode-hook #'smartparens-mode)))

(use-package ivy
  :config
  (progn
    (use-package counsel)
    (use-package swiper)

    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-count-format "(%d/%d) ")

    (global-set-key (kbd "C-s") 'swiper-isearch)
    (global-set-key (kbd "C-r") 'swiper-isearch-backward)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "M-y") 'counsel-yank-pop)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-find-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "<f2> j") 'counsel-set-variable)
    (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
    (global-set-key (kbd "C-c v") 'ivy-push-view)
    (global-set-key (kbd "C-c V") 'ivy-pop-view)

    ))

;; Use view mode in read-only buffers
(setq view-read-only t)

;; Support direnv
(use-package envrc
  :config
  (progn
    (define-key envrc-mode-map (kbd "C-c e") 'envrc-command-map)
    (envrc-global-mode)))
