;;; ltl-rust.el --- rust and basic lsp config.
;;; Commentary:

;; rustic + lsp-mode + yasnippet

;;; Code:

(use-package lsp-mode
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-lens-enable nil)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-delay 1)
  :config
  (lsp-enable-which-key-integration t)
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay 0.6)
  (lsp-inlay-hint-enable t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names t)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-display-reborrow-hints "never")
  (lsp-rust-analyzer-binding-mode-hints t)
  (lsp-rust-analyzer-call-info-full t)
  (lsp-rust-analyzer-closure-capture-hints t)
  (lsp-rust-analyzer-closure-return-type-hints "always")
  (lsp-rust-analyzer-discriminants-hints "never")
  (lsp-rust-analyzer-expression-adjustment-hints "never")
  (lsp-rust-analyzer-implicit-drops nil)
  (lsp-headerline-breadcrumb-enable nil)
;;  (lsp-rust-analyzer-max-inlay-hint-length nil)
  :hook
  (lsp-mode . lsp-ui-mode)
  (c-mode . lsp)
  (c++-mode . lsp))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
;;  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-update-mode t)
  (lsp-ui-sideline-delay 0.6)
  (lsp-ui-sideline-diagnostic-max-lines 3))

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  (setq eldoc-documentation-functions nil)
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-signature-auto-activate t)

  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(use-package tree-sitter
 :config
 (global-tree-sitter-mode)
 (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs)


(use-package yasnippet
  :functions yas-reload-all
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package flycheck
  :config
  (setq-default flycheck-emacs-lisp-load-path 'inherit)
  :hook(after-init . global-flycheck-mode))

(defun rk/rustic-mode-hook ()
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))

(defvar my-cpp-other-file-alist
  '(("\\.cpp\\'" (".hpp" ".ipp"))
    ("\\.ipp\\'" (".hpp" ".cpp"))
    ("\\.hpp\\'" (".ipp" ".cpp"))
    ("\\.cxx\\'" (".hxx" ".ixx"))
    ("\\.ixx\\'" (".cxx" ".hxx"))
    ("\\.hxx\\'" (".ixx" ".cxx"))
    ("\\.c\\'" (".h"))
    ("\\.h\\'" (".c"))
    ))
(setq-default ff-other-file-alist 'my-cpp-other-file-alist)

(add-hook 'c-initialization-hook (lambda () (local-set-key (kbd "C-c o") 'ff-find-other-file)))

(provide 'ltl-rust)

;;; ltl-rust.el ends here.

