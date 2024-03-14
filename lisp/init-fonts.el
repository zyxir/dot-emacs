;;; init-fonts.el --- Font settings.  -*- lexical-binding: t -*-
;;; Commentary:

;; This file sets font for various faces and multiple character sets. A
;; objective of these settings is to make the width of one Chinese character
;; equal that of two Latin characters, so that these two lines could align:
;;
;; 這句話一共由十三個漢字組成
;; abcdefghijklmnopqrstuvwxyz

;;; Code:


;;;; Font Setting Utility

(defvar zy/-fontset-cnt 0
  "Number of fontsets generated by `zy/set-face-charset-font'.")

(defconst zy/cjk-charsets '(han cjk-misc bopomofo kana hangul)
  "CJK character sets.")

;; Font faces setup

(defcustom zy/font-size 16
  "The pixel size of font in `default' face."
  :type 'integer
  :group 'zyemacs
  :set #'(lambda (sym size)
           (set sym size)
           (when (fboundp 'zy/setup-font-faces)
             (zy/setup-font-faces))))

(defun zy/set-face-charset-font (face frame charset font)
  "Set the font used for character set CHARSET in face FACE.

This function has no effect if `display-graphic-p' returns nil,
since fontset is not supported in console mode.

FRAME specifies the frame to set in. When FRAME is nil or
omitted, set it for all existing frames, as well as the default
for new frames.

CHARSET specifies the character set to set font for. CHARSET
could also be a list of character sets, where every character set
will be set for.

FONT is the font to be set. It can be a `font-spec' object, or a
font name string.

This is a convenient method to set font for specific character
set (like CJK characters or symbols). However, the fontset system
of Emacs is complicated, and not very straightforward. Instead of
playing with `font-spec', fontsets and frame attributes, this
function provides a simpler interface that just work."
  (when (display-graphic-p)
    (let* (;; The fontset that we are going to manipulate
           (fontset (face-attribute face :fontset frame))
           ;; If the fontset is not specified
           (unspecified-p (equal fontset 'unspecified)))
      ;; If the fontset is not specified, create a new one with a
      ;; programmatically generated name
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
                  (set-fontset-font fontset c font frame 'prepend))
                charset)
        (set-fontset-font fontset charset font frame))
      ;; Assign the fontset to the face if necessary
      (when unspecified-p
        (set-face-attribute face frame :fontset fontset)))))


;;;; The Actual Setup

;; I used to write very flexible font configuration codes that defines a tons of
;; faces and automatically picks the first available font from a list, but that
;; turned out to be too complicated and heavy. Now I just hard-coded the font
;; names and rely on the default font fallback mechanism.

;; Anyway this is just my personal configuration, I can change the code at any
;; time.

(defun zy/setup-font-faces ()
  "Setup font faces as I like.
Does not work without GUI."
  (interactive)
  (defvar zy/font-size)
  ;; Default face.
  (set-face-attribute 'default nil
                      :font (font-spec :family "Sarasa Mono HC"
                                       :size zy/font-size))
  (zy/set-face-charset-font 'default nil zy/cjk-charsets "Sarasa Mono HC")
  ;; Fixed-pitch face.
  (set-face-attribute 'fixed-pitch nil :font "Sarasa Mono HC"
                      :height 'unspecified)
  (zy/set-face-charset-font 'fixed-pitch nil
                            zy/cjk-charsets "Sarasa Mono HC")
  ;; Variable-pitch face.
  (set-face-attribute 'variable-pitch nil :font "Noto Sans")
  (zy/set-face-charset-font 'variable-pitch nil
                            zy/cjk-charsets "Sarasa Mono HC"))

(defun zy/maybe-setup-font-faces (&rest _)
  "Try to setup font faces.

If GUI is not available currently, add itself to
`after-make-frame-functions', so that it can be run again the
next time a frame is created.

If GUI is available, setup font with `zy/setup-font-faces', and
remove itself from `after-make-frame-functions' if it is there.
Return what `zy/setup-font-faces' returns."
  (if (display-graphic-p)
      (prog1
          (condition-case e
              (zy/setup-font-faces)
            (error (lwarn 'font :warning "%s: %s" (car e) (cdr e))))
        (remove-hook! '(after-make-frame-functions
                        server-after-make-frame-hook)
          #'zy/maybe-setup-font-faces))
    (add-hook! '(after-make-frame-functions
                 server-after-make-frame-hook)
      #'zy/maybe-setup-font-faces)))

(zy/maybe-setup-font-faces)

(provide 'init-fonts)

;;; init-fonts.el ends here
