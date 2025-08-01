;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;;;;;  AUTO INSTALL MY PACKAGES
(setq my-melpa-packages '(color-theme-sanityinc-tomorrow helm ivy json-mode magit markdown-mode markdown-toc moe-theme projectile
							 python-mode scala-mode terraform-mode
							 typescript-mode yaml-mode helm-projectile lsp-mode company lsp-metals doom-modeline nerd-icons rust-mode lua-mode smartparens
							 helm-swoop doom-themes material-theme ace-window winum))
;; Fetch list of packages available
(unless package-archive-contents
  (package-refresh-contents))
;; Install the packages
(dolist (package my-melpa-packages)
  (unless (package-installed-p package)
    (package-install package)))
(require 'use-package)
;;;;;; --------------

;; (require 'color-theme-sanityinc-tomorrow)
;; (load-theme 'color-theme-sanityinc-tomorrow-night t)
;;
;; see https://emacs.stackexchange.com/questions/2797/emacs-wont-load-theme-on-startup
;; (add-hook 'after-init-hook (lambda () (load-theme 'solarized-light)))


;; Font
;; Must run `nerd-icons-install-fonts` for icons to render
(setq nerd-icons-font-family "JetBrainsMono Nerd Font Mono")

;; Modeline
(require 'doom-modeline)
(doom-modeline-mode 1)

;; HELM
(require 'helm)
(helm-mode t)
;; (require 'helm-config)
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") #'helm-select-action)

(winum-mode t)

;; Which key
(require 'which-key)
(which-key-mode 1)

(defvar-keymap my-window-prefix-map
	:doc "Window"
	"d" #'delete-window
	"|" #'split-window-right
	"-" #'split-window-below
 	"u" #'delete-other-windows
	"<right>" #'windmove-right
	"<down>" #'windmove-down
	"<left>" #'windmove-left
	"<up>" #'windmove-up)


;; Project keymap?
;; LSP keymap?
(defvar-keymap my-prefix-map
	:doc "My Prefix map!"
  "d" #'dired
	"1" #'winum-select-window-1
	"2" #'winum-select-window-2
	"3" #'winum-select-window-3
 	"4" #'winum-select-window-4
	"5" #'winum-select-window-5
	"6" #'winum-select-window-6
	"7" #'winum-select-window-7
	"8" #'winum-select-window-8
	"9" #'winum-select-window-9)

(define-key my-prefix-map (kbd "w") my-window-prefix-map)
(keymap-set global-map "s-." my-prefix-map)

(setq which-key-show-early-on-C-h t)
;; (setq which-key-idle-delay 10000)
;; (setq which-key-idle-secondary-delay 0.05)

;; Smartparens
(require 'smartparens)
(smartparens-mode t)


;; Projectile
(require 'projectile)
(require 'helm-projectile)
(projectile-mode +1)
(setq projectile-project-search-path '("~/projects"))
(setq projectile-cleanup-known-projects nil)
(projectile-discover-projects-in-search-path)

;; Company
(require 'company)
(company-mode 1)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0.3)
;; TAB to complete?
;; (with-eval-after-load 'company
;;	(define-key company-mode-map (kbd "<tab>") 'company-complete-selection))
(setq company-backends '((company-capf company-dabbrev-code)))


;; Company fuzzy
;; (use-package company-fuzzy
;;   :hook (company-mode . company-fuzzy-mode)
;;   :init
;;   (setq company-fuzzy-sorting-backend 'flx
;;         company-fuzzy-reset-selection t
;;         company-fuzzy-prefix-on-top nil
;;         company-fuzzy-trigger-symbols '("." "->" "<" "\"" "'" "@")))
;; (global-company-fuzzy-mode 1)

;; LSP
(use-package lsp-metals
  :ensure t
  :custom
  ;; You might set metals server options via -J arguments. This might not always work, for instance when
  ;; metals is installed using nix. In this case you can use JAVA_TOOL_OPTIONS environment variable.
  (lsp-metals-server-args '(;; Metals claims to support range formatting by default but it supports range
                            ;; formatting of multiline strings only. You might want to disable it so that
                            ;; emacs can use indentation provided by scala-mode.
                            "-J-Dmetals.allow-multiline-string-formatting=off"
                            ;; Enable unicode icons. But be warned that emacs might not render unicode
                            ;; correctly in all cases.
                            "-J-Dmetals.icons=unicode"))
  ;; In case you want semantic highlighting. This also has to be enabled in lsp-mode using
  ;; `lsp-semantic-tokens-enable' variable. Also you might want to disable highlighting of modifiers
  ;; setting `lsp-semantic-tokens-apply-modifiers' to `nil' because metals sends `abstract' modifier
  ;; which is mapped to `keyword' face.
  (lsp-metals-enable-semantic-highlighting t)
  :hook (scala-mode . lsp))
;; Add metals backend for lsp-mode
(use-package lsp-metals)

;; Metals
;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
  :interpreter ("scala" . scala-mode))
(use-package lsp-mode
	:hook (scala-mode . lsp)
  (lsp-mode . lsp-lens-mode)
	:config (setq lsp-keep-workspace-alive nil)
	)


;; General stuff
(tool-bar-mode -1)
(setq-default cursor-type 'bar)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq-default tab-width 2)
(setq fill-column 80)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(setq scroll-margin 8)
(set-face-attribute 'default nil :height 130)
(electric-pair-mode t)
(global-display-line-numbers-mode t)
(delete-selection-mode t)


;; Explictly map file types to modes
(add-to-list 'auto-mode-alist '("\\.scala\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("\\.sbt\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-mode))


;; Key bindings
(require 'magit)

(global-set-key (kbd "s-o") 'helm-find-files)
(global-set-key (kbd "s-b") 'helm-buffers-list)
(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
(global-set-key (kbd "s-<down>") 'end-of-buffer)
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-g") 'magit)
(global-set-key (kbd "s-f") 'helm-swoop)
(global-set-key (kbd "s-F") 'helm-projectile-grep)
(global-set-key (kbd "s-B") 'helm-projectile-switch-to-buffer)
;; (global-set-key (kbd "s-/") 'comment-region)
;;
;; Switch project
(define-key projectile-mode-map (kbd "s-p") 'helm-projectile-switch-project)
(define-key projectile-mode-map (kbd "s-O") 'helm-projectile-find-file)

;; Search in file
;; Search in project



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(moe-dark))
 '(custom-safe-themes
	 '("7771c8496c10162220af0ca7b7e61459cb42d18c35ce272a63461c0fc1336015"
     "ba4f725d8e906551cfab8c5f67e71339f60fac11a8815f51051ddb8409ea6e5c"
		 "3061706fa92759264751c64950df09b285e3a2d3a9db771e99bcbb2f9b470037"
		 "088cd6f894494ac3d4ff67b794467c2aa1e3713453805b93a8bcb2d72a0d1b53"
		 "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8"
		 "4d5d11bfef87416d85673947e3ca3d3d5d985ad57b02a7bb2e32beaf785a100e"
		 "8899e88d19a37d39c7187f4bcb5bb596fba990728ef963420b93e2aea5d1666a"
		 "6fc9e40b4375d9d8d0d9521505849ab4d04220ed470db0b78b700230da0a86c1" default))
 '(package-selected-packages
	 '(color-theme-sanityinc-tomorrow company company-fuzzy company-mode
																		doom-modeline doom-themes helm helm-projectile helm-rg
																		helm-swoop ivy json-mode lsp-metals lsp-mode
																		lua-mode magit markdown-toc material-theme
																		moe-theme projectile python-mode rg ripgrep
																		rust-mode scala-mode smartparens
																		terraform-mode typescript-mode winum
																		yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
