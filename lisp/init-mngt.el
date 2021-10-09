;;; -*- coding: utf-8; lexical-binding: t; -*-
;;; Commentary:

;; This file configures package management utilities.

;;; Code:

;;;; Package management

;; Make sure that straight.el is installed.

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Manage package and settings with use-package.

(straight-use-package 'use-package)
(setq straight-vc-git-default-clone-depth 1)

;; Hide mode text with delight.

(use-package delight
  :straight t)

;;;; Keybinding management

;; Shortcut hint with which-key.

(use-package which-key
  :straight t
  :defer 2
  :delight
  :config
  ;; Popup side window on bottom.
  (which-key-setup-side-window-bottom)
  ;; Show which-key on C-h.
  (setq which-key-show-early-on-C-h t)
  (which-key-mode +1))

;; Manage shortcuts with general.

(use-package general
  :straight t)

;;;; Minibuffer

;; Minibuffer completion with the ivy suite.

(use-package ivy
  :straight t
  :delight
  :general
  ("M-x" 'counsel-M-x
   "C-x C-f" 'counsel-find-file
   "C-h v" 'counsel-describe-variable
   "C-h f" 'counsel-describe-function
   "C-x b" 'ivy-switch-buffer)
  :init
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t
	ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  :config
  (ivy-mode +1))

(use-package counsel
  :straight t
  :after ivy
  :delight
  :general
  ("M-s g" 'counsel-rg)
  :config
  (counsel-mode +1))

;; Install smex, which will be automatically used by counsel-M-x.

(use-package smex
  :straight t)

(use-package swiper
  :straight t
  :after ivy
  :general
  ("C-s" 'swiper-isearch
   "C-r" 'swiper-isearch-backward))

;; End of config.

(provide 'init-mngt)
