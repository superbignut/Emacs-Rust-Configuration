;;; init.el --- Load the full configuration ;; -*- lexical-binding:
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files in the lisp/ folder.

;; Besides, the order of the followed configuration is meaningful.

;;; Code:
(if (window-system) (set-frame-size (selected-frame) 190 55)) ;;window size.

(defun frame-center ()
  "Center the current frame."
  (interactive)
  (let* ((dw (display-pixel-width))
         (dh (display-pixel-height))
         (f  (selected-frame))
         (fw (frame-pixel-width f))
         (fh (frame-pixel-height f))
         (x  (- (/ dw 2) (/ fw 2)))
         (y  (- (/ dh 2) (/ fh 2))))
    (message (format "dw %d dh %d fw %d fh %d x %d y %d" dw dh fw fh x y))
    (set-frame-position f x y)))

(frame-center) ;; center the window, must be used after set-frame-size.

(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp")))

;; (setq auto-save-file-name-transforms
;;           `((".*" ,(concat user-emacs-directory "auto-save") t)))

;; (setq backup-directory-alist
;;       `(("." . ,(expand-file-name (concat user-emacs-directory "backups")))))

(defun split-and-follow-horizontally ()
  "."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  "."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(defun copy-line ()
  "Copy lines."
  (interactive)
  (save-excursion
    (back-to-indentation)
    (kill-ring-save
     (point)
     (line-end-position)))
     (message "1 line copied"))

(global-set-key "\C-c\C-k" 'copy-line)

(tool-bar-mode -1) ;;close tool-bar

(scroll-bar-mode -1) ;;close-scroll-bar

(menu-bar-mode -1) ;;close menu-bar

(tooltip-mode -1) ;;close pop-up info window.

(show-paren-mode t) ;;show () when come across.

(set-fringe-mode 10) ;;add fringe of window;

(column-number-mode 1) ;;column number in the modeline.

;;(electric-pair-mode 1) ;; {} auto completion.

(setq-default cursor-type 'hollow)
;; (setq scroll-margin 20) ;;scroll when access margin number.

;; (setq scroll-conservatively 10) ;; use with scroll-margin to close focus-scrolling.

(global-display-line-numbers-mode 1) ;;show line number.

(put 'narrow-to-region 'disabled nil) ;;auto-genenrate.

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ;;Esc to quit.

(dolist (mode (list 'org-mode-hook
 		    'term-mode-hook
		    'shell-mode-hook
		    'treemacs-mode-hook
		    'eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

(defun open-init-file()
  "Use <f2>, open init.el."
  (interactive)
  (find-file "~/.emacs.d/init.el")) ;;<f2> -> init.el.

(global-set-key (kbd "<f2>") 'open-init-file)

(global-set-key (kbd "M-[") 'previous-buffer)

(global-set-key (kbd "M-]") 'next-buffer)

(global-set-key (kbd "C-h C-f") 'find-function)

(global-set-key (kbd "M-p") (lambda () (interactive) (move-to-window-line 0)))

(global-set-key (kbd "M-n") (lambda () (interactive) (move-to-window-line -1)))

(setq visible-bell t) ;; flash replace bell.

(setq inhibit-startup-screen -1)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq package-archives '(
			 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

(require 'package)


(unless (bound-and-true-p package--initialized)
  (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package) ;; include treemacs in other file.

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(require 'ltl-treemacs)

(require 'ltl-rust)

;; (add-to-list 'load-path
;; 	     (expand-file-name (concat user-emacs-directory "lisp/lsp-bridge")))

;; (require 'lsp-bridge)
;; (global-lsp-bridge-mode)


(use-package marginalia
  :init
  (marginalia-mode))

(use-package paredit
  :hook
  (emacs-lisp-mode . paredit-mode)
  (lisp-interaction-mode . paredit-mode))

(use-package rainbow-delimiters
  :hook
  (emacs-lisp-mode . rainbow-delimiters-mode)
  (lisp-interaction-mode . rainbow-delimiters-mode))

(use-package helm
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files) ;;
	 ("M-y" . helm-show-kill-ring) ;;emacs kill ring plus
         ("C-M-j" . helm-mini) ;;
         ("C-M-j" . helm-buffers-list) ;;
         ("C-c h o" . helm-occur) ;; find in temp file.
         ("C-c h i" . helm-imenu) ;; show emacs imenu.
	 ("C-c h s" . helm-occur-visible-buffers)
         ;; helm-man-woman C-c c m ;;
         ;; helm-find ;;
         ("C-c h g" . helm-do-grep-ag)) ;; ag in temp project.
  :init
  (helm-mode 1)
  (setq helm-use-frame-when-more-than-two-windows t))

(use-package company
  :hook(after-init . global-company-mode);
  :config
  (setq  company-minimum-prefix-length 1
	 company-idle-delay 0.1	 company-tooltip-align-annotations t
	 company-tooltip-limit 20
	 company-show-quick-access t))

(require 'company)

(defun set-company-tab ()
  "."
  (define-key company-active-map [tab] 'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-select-next-if-tooltip-visible-or-complete-selection)
  )

(set-company-tab)


(use-package projectile
  :init
  (projectile-mode 1)
  :bind (:map projectile-mode-map
	      ("C-c p" . projectile-command-map))
  :config
  (setq shell-file-name "/bin/bash"))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-themes
  :init
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-dark+ t)
  (doom-themes-visual-bell-config))
;;  :config
;; (custom-set-faces
;;  `(mode-line ((t (:background ,(doom-color '("#68217A"))))))))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; (use-package solarized-theme
;;   :init
;;   (load-theme 'solarized-dark t))
(use-package ace-window
  :bind (("M-o" . 'ace-window)))

(use-package ag)

(use-package which-key
  :init
  (which-key-mode))

(use-package beacon
  :init
  (beacon-mode 1)
  (setq beacon-blink-when-point-moves-vertically 1)
  (setq beacon-color "#720F90"))

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-command)
   ("C-c C-d" . helpful-at-point)
   ("C-h F" . helpful-function)))

(use-package avy
  :bind (("C-'" . avy-goto-char-timer)
         ("C-c C-j" . avy-resume))
  :config
  (setq avy-background t
        avy-all-windows t
        avy-timeout-seconds 0.3))

(use-package ctrlf
  :config
  (ctrlf-mode t))

(use-package magit)

;; (use-package evil
;;   :init
;;   (setq evil-want-integration t)
;;   (setq evil-want-keybinding nil)
;;   (setq evil-want-C-u-scroll t)
;;   (setq evil-want-C-i-jump nil)
;;   :config
;;   (evil-mode 1)
;;   (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;;   ;; (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

;;   ;; Use visual line motions even outside of visual-line-mode buffers
;;   (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;;   (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

;;   (evil-set-initial-state 'messages-buffer-mode 'normal)
;;   (evil-set-initial-state 'dashboard-mode 'normal))

;; (use-package evil-collection
;;   :after evil
;;   :config
;;   (evil-collection-init))

(use-package org)

(use-package smartparens-config
  :ensure smartparens
  :init
  (smartparens-global-mode 1))

;; (require 'make-mode)

(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

;; (treemacs)
;; (treemacs-select-window)
;;; init.el ends here



