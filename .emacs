
;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; TODO: Include steps here to install un-installed packages?
(setq my-melpa-packages '())

;; (require 'color-theme-sanityinc-tomorrow)
;; (load-theme 'color-theme-sanityinc-tomorrow-night t)
;;
;; see https://emacs.stackexchange.com/questions/2797/emacs-wont-load-theme-on-startup
;; (add-hook 'after-init-hook (lambda () (load-theme 'solarized-light)))



;; HELM
(require 'helm)
;; (require 'helm-config)
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") #'helm-select-action)

;; Which key
(require 'which-key)
(which-key-mode 1)



(setq-default cursor-type 'bar)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq-default tab-width 2)
(setq fill-column 80)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(setq scroll-margin 8)
(set-face-attribute 'default nil :height 130)


;; Key bindings

(global-set-key (kbd "s-o") 'helm-find-files)
(global-set-key (kbd "s-b") 'helm-buffers-list)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(moe-dark))
 '(custom-safe-themes
	 '("8899e88d19a37d39c7187f4bcb5bb596fba990728ef963420b93e2aea5d1666a"
		 "6fc9e40b4375d9d8d0d9521505849ab4d04220ed470db0b78b700230da0a86c1" default))
 '(package-selected-packages
	 '(color-theme-sanityinc-tomorrow helm ivy json-mode magit markdown-mode
																		markdown-toc moe-theme projectile
																		python-mode scala-mode terraform-mode
																		typescript-mode yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
