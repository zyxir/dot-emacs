;;; init-ui.el --- User interface setup -*- lexical-binding: t -*-

;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Settings about the user interface, either graphical or terminal.

;;; Code:

(require 'init-keybinding)
(require 'init-load)


;;;; Setup Modus Themes

(setq-default
 modus-themes-italic-constructs nil
 modus-themes-lang-checkers '(background)
 modus-themes-bold-constructs t
 modus-themes-headings '((0 . (background rainbow 1.1))
			 (1 . (overline rainbow 1.3))
			 (2 . (overline rainbow 1.2))
			 (3 . (overline 1.1))
			 (t . (monochrome)))
 modus-themes-hl-line '(intense)
 modus-themes-markup '(background intense)
 modus-themes-mixed-fonts t
 modus-themes-region '(accented no-extend)
 modus-themes-org-blocks '(gray-background)
 modus-themes-prompts '(background))

(load-theme 'modus-vivendi 'no-confirm)

(zy/define-key :keymap 'zy/leader-toggle-map
  "t" '("Toggle light/dark" . modus-themes-toggle))


;;;; Mode Lighters

(straight-use-package 'dim)

(zy/defsnip 'snip-dim
  (dim-minor-names
   '((beacon-mode "" beacon)
     (clipetty-mode "" clipetty)
     (eldoc-mode "" eldoc)
     (outline-minor-mode "" outline)
     (page-break-lines-mode "" page-break-lines)
     (smartparens-mode "" smartparens)
     (subword-mode "" subword)
     (which-key-mode "" which-key)
     (yas-minor-mode "" yasnippet))))

(zy/incload-register 'snip-dim :priority 10)


;;;; Setup Fonts

;; Font setter for other character sets

(defvar zy/-fontset-cnt 0
  "Number of fontsets generated by `zy/set-face-charset-font'.")

(defun zy/set-face-charset-font (face frame charset font)
  "Set the font used for character set CHARSET in face FACE.

FRAME specifies the frame to set in.  When FRAME is nil or
omitted, set it for all existing frames, as well as the default
for new frames.

CHARSET specifies the character set to set font for.  CHARSET
could also be a list of character sets, where every character set
will be set for.

FONT is the font to be set.  It can be a `font-spec' object, or a
font name string.

This is a convenient method to set font for specific character
set (like CJK characters or symbols).  However, the fontset
system of Emacs is complicated, and not very straightforward.
Instead of playing with `font-spec', fontsets and frame
attributes, this function provides a simpler interface that just
does the job."
  (let* (;; The fontset that we are going to manipulate
	 (fontset (face-attribute face :fontset frame))
	 ;; If the fontset is not specified
	 (unspecified-p (equal fontset 'unspecified)))
    ;; If the fontset is not specified, create a new one with a programmatically
    ;; generated name
    (when unspecified-p
      (setq fontset
	    (new-fontset
	     (format "-*-*-*-*-*--*-*-*-*-*-*-fontset-zy%d"
		     zy/-fontset-cnt)
	     nil)
	    zy/-fontset-cnt (+ 1 zy/-fontset-cnt)))
    ;; Set font for the fontset
    (if (listp charset)
	(mapc (lambda (c)
		(set-fontset-font fontset c font frame))
	      charset)
      (set-fontset-font fontset charset font frame))
    ;; Assign the fontset to the face if necessary
    (when unspecified-p
      (set-face-attribute face frame :fontset fontset))))

(defconst zy/cjk-charsets '(han cjk-misc bopomofo kana hangul)
  "CJK character sets.")

(defmacro zy/pick-font (&rest fonts)
  "Get the first available font in FONTS.

Each element of FONTS is a string representing a frame."
  (let ((or-sexp '(or)))
    (mapc (lambda (font)
	    (push `(when (x-list-fonts ,font) ,font) or-sexp))
	  fonts)
    (reverse or-sexp)))

;; Font faces setup

(defvar zy/setup-font-faces nil
  "If `zy/setup-font-faces' has executed.")

(defun zy/setup-font-faces (&optional ignored force)
  "Setup font faces.

Optional argument IGNORED is ignored, so that the function
ignores the FRAME argument given by `after-make-frame-functions'.

This function does not execute if its symbol value is t, unless
optional argument FORCE is non-nil."
  (when (or force (not zy/setup-font-faces))
    ;; Default face
    (set-face-attribute 'default nil :font "Fira Code")
    (zy/set-face-charset-font 'default nil zy/cjk-charsets
			      (zy/pick-font "Sarasa Mono CL"
					    "Microsoft YaHei"
					    "monospace"))
    ;; Fixed-pitch face
    (set-face-attribute 'fixed-pitch nil
			:font "Fira Code"
			:height 'unspecified)
    ;; ZyEmacs sans-serif face
    (defface zy-sans nil "Sans-serif font face."
      :group 'basic-faces)
    (set-face-attribute 'zy-sans nil
      :font (zy/pick-font "Roboto" "Calibri" "sans-serif"))
    (zy/set-face-charset-font 'zy-sans nil zy/cjk-charsets
			      (zy/pick-font "Sarasa Mono CL"
					    "Microsoft YaHei"
					    "monospace"))
    (setq zy/setup-font-faces t)))

(if (display-graphic-p)
    (zy/setup-font-faces)
  (add-to-list 'after-make-frame-functions
	       #'zy/setup-font-faces))


;;;; Distraction-Free Mode

(straight-use-package 'darkroom)

(zy/incload-register 'darkroom)

(zy/define-key
  :keymap 'zy/leader-toggle-map
  "d" '("Darkroom" . darkroom-tentative-mode))

(with-eval-after-load 'darkroom
  (add-hook 'darkroom-tentative-mode-hook
	    (lambda ()
	      (display-line-numbers-mode 'toggle)
	      (hl-line-mode 'toggle))))


(provide 'init-ui)

;;; init-ui.el ends here.
