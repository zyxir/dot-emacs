;;; init.el --- Boostrap config modules.  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;;; Preparations

;; Check Emacs version.
(let ((minver "29.1"))
  (when (version< emacs-version minver)
    (error "Emacs %s or higher is required to run Zyxir's config." minver)))

;; Determine the operating system.
(defvar zy/os-wsl-p (file-exists-p "/etc/wsl.conf")
  "If Emacs is running on WSL.")
(defvar zy/os
  (cond ((member system-type '(ms-dos windows-nt cygwin))
	 windows)
	((eq system-type 'gnu/linux)
	 (if zy/os-wsl-p 'wsl 'linux))
	(t 'unsupported))
  "The operating system Emacs is running on.
Possible values:
  `windows'     Microsoft Windows
  `wsl'         Windows subsystem for Linux
  `linux'       a Linux distribution
  `unsupported' an unsupported system")

;;;; Load modules.

(defconst zy/lisp-dir (expand-file-name "lisp" user-emacs-directory)
  "Directory containing modules of Zyxir's Emacs config.")

(defun require-init (module)
  "Load MODULE of Zyxir's config."
  (load (expand-file-name (symbol-name module) zy/lisp-dir)
	'noerror 'nomessage))

(let ((file-name-handler-alist nil))

  ;; Load the custom file first.
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (load custom-file 'noerror 'nomessage)

  ;; Basic modules.
  (require-init 'init-elpa)
  (require-init 'init-util)
  (require-init 'init-misc)
  (require-init 'init-keybindings)

  ;; Text-editing and coding.
  (require-init 'init-paragraph)
  (require-init 'init-snippet)
  (require-init 'init-completion)
  (require-init 'init-vc)

  ;; Look and feel.
  (require-init 'init-theme)
  (require-init 'init-fonts)

  ;; File type specific.
  (require-init 'init-python))

(provide 'init)
