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

;; c/cpp modes
;;  (add-hook 'c++-mode-hook 'irony-mode)
;;  (add-hook 'c-mode-hook 'irony-mode)
;;  (add-hook 'objc-mode-hook 'irony-mode)
;;  (eval-after-load 'company
;;    '(add-to-list 'company-backends 'company-irony))

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
  :mode "\\.nix$")

;; Better js mode
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
(use-package indium
  :defer 1
  :config
  (progn
    (add-hook 'js-mode-hook #'indium-interaction-mode)
    (setq mocha-debugger 'indium)))

;; Global magit keys
(global-set-key (kbd "C-x g") 'magit-status) ; Display the main magit popup
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup) ; Display keybinds for magit

;; Autocomplete
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
(progn
  (setq-default smooth-scroll-margin 2))

;; Fancy search
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-r") 'swiper)

;; Global webpaste shortcuts
(global-set-key (kbd "C-c C-p C-b") 'webpaste-paste-buffer)
(global-set-key (kbd "C-c C-p C-r") 'webpaste-paste-region)

;; Smart mode line
(progn
  (setq sml/theme 'powerline)
  (setq sml/no-confirm-load-theme t)
  (sml/setup))

;; Always attempt flycheck
(global-flycheck-mode)

;; Smart parens
(progn
  (add-hook 'js-mode-hook #'smartparens-mode)
  (add-hook 'html-mode-hook #'smartparens-mode)
  (add-hook 'python-mode-hook #'smartparens-mode)
  (add-hook 'lua-mode-hook #'smartparens-mode)
  (add-hook 'ruby-mode-hook #'smartparens-mode)
  (add-hook 'rust-mode-hook #'smartparens-mode))

;; Org-exports
(eval-after-load "org"
  '(require 'ox-gfm nil t))

(defun x11-wm-init ()
  (progn
    (require 'exwm)
    (require 'exwm-randr)
    (require 'dbus)

    (defun pnh-run (command)
      (interactive (list (read-shell-command "$ ")))

      (dbus-call-method
       :session "com.github.adisbladis.AppLauncher"
       "/com/github/adisbladis/AppLauncher"
       "com.github.adisbladis.AppLauncher" "Start"
       (split-string command)))

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
    (setq desktop-environment-screenshot-command "flameshot gui")

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

    ;; Using ido to change "tabs" in Firefox!
    ;;
    ;; For this to work properly you need to stop opening new tabs and open
    ;; everything in new windows. It sounds crazy, but then you can use ido
    ;; to switch between "tabs" and everything is wonderful.
    ;;
    ;; Step 1: about:config -> browser.tabs.opentabfor.middleclick -> false
    ;; Step 2: change whatever "open link in new tab" binding in Saka Key or
    ;;         whatever you use to open the link in a new window
    ;; Step 3: rebind ctrl-t to open a new window as well
    ;; Step 4: place the following in chrome/userChrome.css in your FF profile:
    ;;         #tabbrowser-tabs { visibility: collapse !important; }
    ;; Step 5: add this code to your exwm config:
    ;; Step 6: restart your browser and enjoy your new C-x b fanciness!
    ;; (defun pnh-trim-non-ff ()
    ;;   (cl-delete-if-not
    ;;    (apply-partially 'string-match "- Mozilla Firefox$")
    ;;    ido-temp-list))

    ;; (add-hook
    ;;  'exwm-manage-finish-hook
    ;;  (defun pnh-exwm-manage-hook ()
    ;;    (when (string-match "Firefox" exwm-class-name)
    ;;      (setq ido-make-buffer-list-hook 'pnh-trim-non-ff))))

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
       (dbus-call-method
        :session "com.github.adisbladis.AppLauncher"
        "/com/github/adisbladis/AppLauncher"
        "com.github.adisbladis.AppLauncher" "Start"
        (split-string "urxvt"))))

    (setq browse-url-firefox-arguments '("-new-window"))
    (setq exwm-randr-workspace-output-plist '(1 "DP-2-2"))
    (require 'exwm-config)
    (exwm-config-default)
    (exwm-randr-enable)
    (server-start)))

(use-package vterm :defer 1)

;; PDF support
(use-package pdf-tools
    :ensure t
    :config
    (pdf-tools-install)
    (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward-regexp)  ;; Pdf and swiper does not work together
    )

(use-package notmuch
  :config
  (progn
    (setq notmuch-show-logo nil)
    (setq notmuch-search-oldest-first nil)))

;; ; gnus-alias
(autoload 'gnus-alias-determine-identity "gnus-alias" "" t)
(setq gnus-alias-identity-alist
      '(("adisbladis-gmail"
         nil ;; Does not refer to any other identity
         "Adam Hose <adisbladis@gmail.com>"
         nil ;; No organization header
         nil ;; No extra headers
         nil ;; No extra body text
         nil ;; No signature
         )
        ("enuma"
         nil
         "Adam Hose <adam.hose@enuma.io>"
         "Enuma Technologies"
         nil
         nil
         nil
         )
        ("trustedkey"
         nil
         "Adam Hose <adam.hose@trustedkey.com>"
         "Trusted Key"
         nil
         nil
         nil
         )
        ))

(setq gnus-alias-default-identity "adisbladis-gmail")
(setq gnus-alias-identity-rules
      '(("@enuma.io" ("any" "@enuma\\.io" both) "enuma")
        ("@trustedkey.com" ("any" "@trustedkey\\.com" both) "trustedkey")))

(setq mail-user-agent 'message-user-agent)
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq message-kill-buffer-on-exit t)
(setq mail-specify-envelope-from t)

(setq sendmail-program "msmtp"
      mail-specify-envelope-from t
      mail-envelope-from 'header
      message-sendmail-envelope-from 'header)

;; Sign messages by default.
(add-hook 'message-setup-hook 'mml-secure-message-sign-pgpmime)
