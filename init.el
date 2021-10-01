;;; -*- coding: utf-8; lexical-binding: t; -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into a number of
;; other files.

;;; Code:

;; Define config file locations.

(defconst zy/emacs-d (file-name-as-directory user-emacs-directory)
  "The path of .emacs.d.")
(defconst zy/lisp-path (concat zy/emacs-d "lisp")
  "The path of all my config files.")
(defconst zy/site-lisp-path (concat zy/emacs-d "site-lisp")
  "The path of all external lisp files.")
(defconst zy/3rd-party-path (concat zy/emacs-d "3rd-party")
  "The path of all 3rd-party tools.")

;; Fast loader for separate config files.

(defun zy/load (pkg &optional maybe-disabled)
  "Load PKG if MAYBE-DISABLED is nil."
  (unless maybe-disabled
    (load (file-truename (format "%s/%s" zy/lisp-path pkg)) nil t)))

;; Load benchmark utils.

(zy/load 'init-benchmark)

;; Management utilities for packages, keybindings, etc..

(zy/load 'init-mngt)

;; Visual things like themes and fonts.

(zy/load 'init-visual)

;; Feature sets.

(zy/load 'init-editing)
(zy/load 'init-files)
(zy/load 'init-vc)

;; Config for different file types.

(zy/load 'init-elisp)

;; End of config.

(provide 'init)
