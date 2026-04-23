;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-material)
(setq doom-theme 'doom-vibrant)
;; (setq doom-theme 'one-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Make the frame maximally large on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq projectile-project-search-path '("~/projects"))

(setq-default tab-width 2)

(setq fill-column 80)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)

(setq scroll-margin 8)

(map! :leader
      ;; Already bound to `SPC w N'
      "1" #'winum-select-window-1
      "2" #'winum-select-window-2
      "3" #'winum-select-window-3
      "4" #'winum-select-window-4
      "5" #'winum-select-window-5
      "6" #'winum-select-window-6
      "7" #'winum-select-window-7
      "w/" #'split-window-right
      "w-" #'split-window-below
      "ee" #'+default/diagnostics
      "en" #'flycheck-next-error
      "ep" #'flycheck-previous-error
      ;; "el" #'+default/diagnostics
      "cn" #'lsp-rename
      "cr" #'lsp-find-references
      "c=" #'lsp-format-buffer
      "ch" #'lsp-ui-doc-show
      ;; "cT" #'lsp-type
      ;;
      "sc" #'evil-ex-nohighlight

      ;; "wu" #'evil-command-window-execute
      ;; "wU" #'winner-undo
      )

(setq doom-modeline-buffer-file-name-style 'truncate-all)

;; Extended keybindings to match Neovim setup
(map! :leader
      ;; Buffer operations (matching <leader>b)
      :prefix ("b" . "buffer")
      ;; "b" #'consult-buffer  ; or persp-switch-to-buffer
      ;; "d" #'kill-this-buffer
      ;; "f" #'consult-recent-file
      ;; "s" #'evil-window-vsplit
      ;; "S" #'evil-window-split
      ;; "n" #'evil-buffer-new

      ;; Code operations (extending existing <leader>c)
      :prefix ("c" . "code")
      "d" #'+lookup/definition
      "i" #'+lookup/implementations
      "c" #'+lookup/documentation
      "s" #'consult-lsp-symbols
      "t" #'lsp-ui-doc-glance
      "a" #'lsp-execute-code-action
      "w" #'lsp-ivy-workspace-symbol

      ;; File operations (matching <leader>f)
      :prefix ("f" . "file")
      "F" #'dired-jump
      "f" #'find-file
      "r" #'projectile-recentf
      "s" #'consult-line

      ;; Git operations (matching <leader>g)
      :prefix ("g" . "git")
      ;; "g" #'magit-status
      ;; "s" #'magit-status
      "l" #'magit-log-buffer-file
      "L" #'magit-log-current
      ;; "b" #'magit-branch-checkout
      "p" #'magit-pull-from-upstream
      "P" #'magit-push
      "f" #'magit-fetch

      ;; Git hunks (matching <leader>gh)
      :prefix ("gh" . "hunk")
      "n" #'git-gutter:next-hunk
      "p" #'git-gutter:previous-hunk
      "d" #'git-gutter:revert-hunk
      "h" #'git-gutter:popup-hunk
      "s" #'git-gutter:stage-hunk

      ;; Git add (matching <leader>ga)
      :prefix ("ga" . "add")
      "a" #'magit-stage-modified
      "A" #'magit-stage-all
      "." #'magit-stage-file

      ;; Help (matching <leader>h)
      :prefix ("h" . "help")
      "t" #'helpful-at-point

      ;; Project operations (matching <leader>p)
      :prefix ("p" . "project")
      "f" #'projectile-find-file
      "s" #'consult-ripgrep
      "S" #'+default/search-project-for-symbol-at-point
      "g" #'consult-git-grep
      "p" #'projectile-switch-project
      "q" #'projectile-kill-buffers

      ;; Quit operations (matching <leader>q)
      ;; :prefix ("q" . "quit")
      ;; "q" #'save-buffers-kill-terminal
      ;; "Q" #'evil-quit-all

      ;; Search operations (matching <leader>s)
      :prefix ("s" . "search")
      ;; "c" already bound to clear highlight (sc)
      "s" #'consult-line
      ;; "r" #'vertico-repeat

      ;; Tab operations (matching <leader>t)
      ;; :prefix ("t" . "tab")
      ;; "t" #'tab-new
      ;; "n" #'tab-next
      ;; "p" #'tab-previous
      ;; "q" #'tab-close
      ;; "1" #'tab-select-1
      ;; "2" #'tab-select-2
      ;; "3" #'tab-select-3

      ;; Additional window operations
      :prefix ("w" . "window")
      "u" #'delete-other-windows
      "=" #'balance-windows
      "3" #'(lambda () (interactive) (split-window-right) (split-window-right) (balance-windows))

      ;; Yank operations (matching <leader>y)
      :prefix ("y" . "yank")
      "f" #'(lambda () (interactive)
              (kill-new (buffer-file-name))
              (message "Copied: %s" (buffer-file-name)))
      "F" #'(lambda () (interactive)
              (kill-new (abbreviate-file-name (buffer-file-name)))
              (message "Copied: %s" (abbreviate-file-name (buffer-file-name))))
      )

;; Non-leader keybindings from remap.lua

;; Center line after search navigation (n and N)
;; (defun my/center-after-search ()
;;   "Recenter after search."
;;   (recenter))

(advice-add 'evil-ex-search-next :after #'recenter)
(advice-add 'evil-ex-search-previous :after #'recenter)

;; Also center for incremental search
(map! :n "n" #'(lambda () (interactive) (evil-ex-search-next) (recenter))
      :n "N" #'(lambda () (interactive) (evil-ex-search-previous) (recenter)))

;; Move visual selection up/down with Shift-Up/Down using drag-stuff
(use-package! drag-stuff
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys))

(map! :v "S-<up>" #'drag-stuff-up
      :v "S-<down>" #'drag-stuff-down)

;; Scroll commands with centering (C-d, C-u, PageUp/Down, Shift-Up/Down)
;; (defun my/scroll-down-center ()
;;   "Scroll down half page and center."
;;   (interactive)
;;   (evil-scroll-down 0)
;;   (recenter))

;; (defun my/scroll-up-center ()
;;   "Scroll up half page and center."
;;   (interactive)
;;   (evil-scroll-up 0)
;;   (recenter))

(map! ;; :n "C-d" #'my/scroll-down-center
      ;; :n "C-u" #'my/scroll-up-center
      ;; :n "<next>" #'my/scroll-down-center   ; PageDown
      ;; :n "<prior>" #'my/scroll-up-center    ; PageUp
      ;; :n "S-<down>" #'my/scroll-down-center
      ;; :n "S-<up>" #'my/scroll-up-center
      :n "M-<left>" #'evil-backward-word-end
      :n "M-<right>" #'evil-forward-word-end
      :n "M-<down>" #'scroll-up ; Alt/Option-Down
      :n "M-<up>" #'scroll-down)    ; Alt/Option-Up

;; Resize splits with Alt-Shift-Arrows
(map! :n "M-S-<left>" #'(lambda () (interactive) (evil-window-decrease-width 5))
      :n "M-S-<right>" #'(lambda () (interactive) (evil-window-increase-width 5))
      :n "M-S-<up>" #'(lambda () (interactive) (evil-window-increase-height 5))
      :n "M-S-<down>" #'(lambda () (interactive) (evil-window-decrease-height 5)))

;; Alt-Arrow word/paragraph navigation
;; (map! :n "M-<right>" #'evil-forward-word-end
;;       :i "M-<right>" #'(lambda () (interactive) (forward-word) (forward-char))
;;       :i "M-<left>" #'backward-word
;;       :i "M-<down>" #'forward-paragraph
;;       :i "M-<up>" #'backward-paragraph)

;; Escape exits terminal mode (vterm)
;; (after! vterm
;;   (define-key vterm-mode-map (kbd "<escape>") #'vterm-send-escape))
;; Paste in visual mode without overriding register
(after! evil

  (define-key evil-visual-state-map "p" #'evil-paste-before))

(set-frame-font "JetBrainsMonoNL Nerd Font Mono" nil t)


(setq tab-always-indent nil)

