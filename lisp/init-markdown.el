;;; -*- coding: utf-8; lexical-binding: t; -*-
;;; Commentary:

;; Settings about Markdown files.

;;; Code:

;; Pandoc is an optional dependency for preview.

(use-package markdown-mode
  :straight t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode)
	 ("README\\.md\\'" . gfm-mode))
  :init
  (setq markdown-command "pandoc -f markdown -t html5")
  :config
  (add-hook 'gfm-mode-hook
	    (lambda ()
	      (setq markdown-command "pandoc -f gfm -t html5"))))

;; Live preview Markdown with grip.

(use-package grip-mode
  :straight t
  :general
  (:keymaps 'markdown-mode-command-map
	    "g" #'grip-mode))

;; Enable C-c ' editing.

(use-package edit-indirect
  :straight t
  :after markdown-mode)

;; End of config.

(provide 'init-markdown)
