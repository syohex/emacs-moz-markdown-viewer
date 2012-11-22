;;; moz-markdown-viewer.el ---

;; Copyright (C) 2012 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL:
;; Version: 0.01

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'cl))

(require 'moz)

(defgroup moz-markdown-viewer nil
  "Markdown Viewer with MozRepl"
  :group 'markdown
  :prefix "moz-markdown-viewer:")

(defvar moz-markdown-viewer:api-url "https://api.github.com/markdown/raw")

(defun moz-markdown-viewer:escape-html (html)
  (replace-regexp-in-string
   "\n" "&#010;"
   (replace-regexp-in-string
    "\"" "&quot;"
    (replace-regexp-in-string "'" "&#39;" html))))

(defun moz-markdown-viewer:update (html)
  (let ((escaped (moz-markdown-viewer:escape-html html)))
    (comint-send-string
     (inferior-moz-process)
     (format "document.getElementById('rendered').innerHTML = \"%s\";" escaped))))

(defun moz-markdown-viewer:escape-input (input)
  (replace-regexp-in-string "\\\\" "\\\\\\\\" input))

(defun moz-markdown-viewer:callback (status)
  (goto-char (point-min))
  (unless (re-search-forward "^$" nil t)
    (error "Not found Responce header"))
  (let ((input (buffer-substring (1+ (point)) (point-max))))
    (moz-markdown-viewer:update (moz-markdown-viewer:escape-input input))))

(defun moz-markdown-viewer:post (input)
  (let ((url-request-method "POST")
        (url-request-data input)
        (url-request-extra-headers '(("Content-Type" . "text/x-markdown"))))
    (url-retrieve moz-markdown-viewer:api-url 'moz-markdown-viewer:callback)))

(defvar moz-markdown-viewer:ready nil)

;;;###autoload
(defun moz-markdown-viewer:render ()
  (interactive)
  (unless moz-markdown-viewer:ready
    (error "Please Enable moz-markdown-viewer-mode"))
  (let ((input (buffer-substring-no-properties (point-min) (point-max))))
    (moz-markdown-viewer:post input)))

(defvar moz-markdown-viewer:html-file "viewer.html")

(defvar moz-markdown-viewer:html-path
  (when load-file-name
    (let ((installed-dir (file-name-directory load-file-name)))
      (concat installed-dir moz-markdown-viewer:html-file))))

;;;###autoload
(defun moz-markdown-viewer:setup ()
  (interactive)
  (when (yes-or-no-p "Open HTML in Firefox? ")
    (browse-url-firefox moz-markdown-viewer:html-path))
  (comint-send-string
   (inferior-moz-process)
   "repl.enter(content);")
  (setq moz-markdown-viewer:ready t))

(provide 'moz-markdown-viewer)

;;; moz-markdown-viewer.el ends here
