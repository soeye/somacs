;;; C++ programming environment
(require 'cc-mode)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; qt-pro-mode
;(require-package 'qt-pro-mode)
;(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))
(use-package qt-pro-mode
  :ensure t
  :mode ("\\.pro\\'" "\\.pri\\'"))


;; build-in mode, Code block folding
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)


;;======================== xref ======================================
;(require-package 'helm-xref)
;(require 'helm-xref)
;(setq xref-show-xrefs-function 'helm-xref-show-xrefs)

;; gxref, xref backend using GNU Global.
(require-package 'gxref)
(require 'gxref)
(add-to-list 'xref-backend-functions 'gxref-xref-backend)


;;======================== lsp mode ==================================
;(require-package 'lsp-mode)
;(require 'lsp-mode)
;(require 'lsp-imenu)
;
;(require-package 'lsp-ui)
;(require 'lsp-ui)
;;(require 'lsp-ui-doc) ; lsp-ui-doc uses child frame which requires Emacs >= 26
;(add-hook 'lsp-mode-hook 'lsp-ui-mode)
;
;(require-package 'company-lsp)
;(require 'company-lsp)
;(add-to-list 'company-backends 'company-lsp)
;
;;;; cquery configuration
;;; https://github.com/jacobdufault/cquery/wiki/Emacs
;;(add-to-list 'load-path "~/.emacs.d/site-lisp/cquery")
;(require 'cquery)
;(setq cquery-executable "/usr/bin/cquery")
;;; lsp-cquery-enable, cquery tries to find the suitable clang resource directory for you. If the heuristics does not work, you can specify one:
;;(setq cquery-resource-dir (expand-file-name "/path/to/cquery/clang_resource_dir/"))
;
;
;(defun my-lsp-setup ()
;  (lsp-cquery-enable)
;  (lsp-enable-imenu)
;  (lsp-ui-mode)
;  (cquery-xref-find-custom "$cquery/base")
;  (cquery-xref-find-custom "$cquery/callers")
;  (cquery-xref-find-custom "$cquery/derived")
;  (cquery-xref-find-custom "$cquery/vars"))

;(add-hook 'lsp-mode-hook 'my-lsp-setup)



;; Alternatively, use lsp-ui-peek interface
;(lsp-ui-peek-find-custom 'base "$cquery/base")
;(lsp-ui-peek-find-custom 'callers "$cquery/callers")


;(defun my//enable-cquery-if-compile-commands-json ()
;  (when-let
;      ((_ (not (and (boundp 'lsp-mode) lsp-mode)))
;       (_ (cl-notany (lambda (x) (string-match-p x buffer-file-name)) my-cquery-blacklist))
;       (root (projectile-project-root))
;       (_ (or (file-exists-p (concat root "compile_commands.json"))
;              (file-exists-p (concat root ".cquery")))))
;    (lsp-cquery-enable)
;    (lsp-enable-imenu)))



;; Semantic configuration
(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
;(global-semantic-stickyfunc-mode 1) ; If enable, click elscreen tab will show menu
(setq semantic-stickyfunc-mode nil)
(semantic-mode 1)


;;======================== Auto complete settings ====================
;; function-args
(require-package 'function-args)
(require 'function-args)
;(fa-config-default) ;; Disable function-args-mode-map keymap


;; dumb-jump
(require-package 'dumb-jump)
(require 'dumb-jump)
(dumb-jump-mode)


;;-------------------------irony for auto complete--------------------
; irony
(require-package 'irony)
(require 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(diminish 'irony-mode "iro")


(when *is-windows*
  (progn
    (setq irony--server-executable "f\:/home/.emacs.d/irony/bin/irony-server.exe")
    ;; Windows performance tweaks
    (when (boundp 'w32-pipe-read-delay)
      (setq w32-pipe-read-delay 0))
    ;; Set the buffer size to 64K on Windows (from the original 4K)
    (when (boundp 'w32-pipe-buffer-size)
      (setq irony-server-w32-pipe-buffer-size (* 64 1024)))))

(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
					;(add-hook 'irony-mode-hook 'my-irony-mode-hook)
					;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


;; company-irony
(require-package 'company-irony)
(require 'company-irony)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))


;; company-irony-c-headers
(require-package 'company-irony-c-headers)
(require 'company-irony-c-headers)
;; Load with `irony-mode` as a grouped backend
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony-c-headers))


;;======================== fast jump settings =====================

(defun my-gtags-setup ()
  (require-package 'helm-gtags)
  (require 'helm-gtags)
  (helm-gtags-mode)
  (add-to-list 'company-backends 'company-gtags))


;; Windows use gtags, linux use ctags
(if *is-windows*
    (my-gtags-setup)
  (my-ctags-setup))



;;========================== navigation ===========================
;; backward-forward, navigation backwards and forwards across marks
;; backward-forward-previous-location <C-left>
;; backward-forward-next-location     <C-right>
(require-package 'backward-forward)
(require 'backward-forward)
(advice-add 'dumb-jump-go :before #'backward-forward-push-mark-wrapper)
(backward-forward-mode t)



;;========================= auto insert code block ================
(define-skeleton skeleton-new-class
  "generate a class" "Class Name:"
  "\nclass " str "\n"
  "{\n"
  "public:\n"
  "    " str "()\n    {\n    }\n\n"
  "    virtual ~" str "()\n    {\n    }\n\n"
  "    " str "(const " str "& other)\n    {\n    }\n\n"
  "    " str "& operator=( const " str "& other)\n"
  "    {\n"
  "        return *this;\n"
  "    }\n"
  "};"
  )

(define-abbrev-table 'c++-mode-abbrev-table '(("newclass" "" skeleton-new-class 1)))




;;-------------------------------cedet-----------------------------
;(require 'cedet)

;
;(require 'ede)
;(global-ede-mode)
;
;;; Include setting
;(require 'semantic/bovine/gcc)
;(require 'semantic/bovine/c)




(provide 'init-cpp-env)
