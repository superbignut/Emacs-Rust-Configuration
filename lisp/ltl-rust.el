;;; ltl-rust.el --- rust and basic lsp config.
;;; Commentary:

;; rustic + lsp-mode + yasnippet + treesiter

;;; Code:

(use-package lsp-mode
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-lens-enable nil)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-delay 1)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-eldoc-enable-hover nil)
  (setq lsp-modeline-code-actions-enable nil)
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
  (c++-mode . lsp)
  (python-mode . lsp))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
;;  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-update-mode t)
  (lsp-ui-sideline-delay 0.6)
  (lsp-ui-sideline-diagnostic-max-lines 5))

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
  (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil)


  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

;; (use-package lsp-python-ms
;;   :init (setq lsp-python-ms-auto-install-server t)
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-python-ms)
;;                          (lsp))))

;; (use-package anaconda-mode
;;   :hook
;;   (python-mode . anaconda-mode))

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



;; (use-package dap-mode
;;   ;; Uncomment the config below if you want all UI panes to be hidden by default!
;;   ;; :custom
;;   ;; (lsp-enable-dap-auto-configure nil)
;;   ;; :config
;;   ;; (dap-ui-mode 1)

;;   :config
;;   ;; Set up Node debugging
;;   (require 'dap-node)
;;   (dap-node-setup) ;; Automatically installs Node debug adapter if needed

;;   ;; Bind `C-c l d` to `dap-hydra` for easy access
;;   ;; (general-define-key
;;   ;;   :keymaps 'lsp-mode-map
;;   ;;   :prefix lsp-keymap-prefix
;;   ;;   "d" '(dap-hydra t :wk "debugger")))
;;   )

(provide 'ltl-rust)

;;; ltl-rust.el ends here.

