;;; zy-direnv.el --- Direnv support. -*- lexical-binding: t -*-

;;; Commentary:

;; This file provides the `+direnv' module of the configuration.

;; Direnv is a cross-shell extension for maintaining directory-local environment
;; variables. Using a ".dir-locals.el" file can provide directory-local
;; variables for Emacs, but it is not a generic solution. Supporting Direnv
;; enables a consistent development environment regardless of the editor or
;; shell you use.
;;
;; Support for Direnv is provided by the Envrc package.

;;; Code:

(require 'zylib)

(pkg! 'envrc)

(add-hook! 'window-setup-hook
  (envrc-global-mode 1))

(after! '(+leader envrc)
  (defprefix! +direnv-map "Direnv"
              nil +leader-c-map "e"
    "a" (cons "Allow" #'envrc-allow)
    "d" (cons "Deny" #'envrc-deny)
    "l" (cons "Log" #'envrc-show-log)
    "r" (cons "Reload" #'envrc-reload)))

(provide 'zy-direnv)

;;; zy-direnv.el ends here
