;;; Ppckage --- pushbullet library

;; This is free and unencumbered software released into the public domain.

;; Anyone is free to copy, modify, publish, use, compile, sell, or
;; distribute this software, either in source code form or as a compiled
;; binary, for any purpose, commercial or non-commercial, and by any
;; means.

;; In jurisdictions that recognize copyright laws, the author or authors
;; of this software dedicate any and all copyright interest in the
;; software to the public domain. We make this dedication for the benefit
;; of the public at large and to the detriment of our heirs and
;; successors. We intend this dedication to be an overt act of
;; relinquishment in perpetuity of all present and future rights to this
;; software under copyright law.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.

;; For more information, please refer to <http://unlicense.org/>

;;; Commentary:

;; Simple (for now) library handling Emacs ↔ Pushbullet interaction.  Based on github.com/theanalyst/revolver

;;; Code:

(require 'request)
(require 'json)

(defvar pushbullet-api-key ""
  "API Key for your pushbullet account."
  )

(defun pb/push-item (title text type)
  "Pushes the item to your devices.  TITLE is title of your push.  TEXT is it's content.  TYPE indicated type of the push, e.g. 'note'."
  (request
   "https://api.pushbullet.com/v2/pushes"
   :type "POST"
   :data (json-encode `(
			("body" . ,text)
			("title" . ,title)
			("type" . ,type)))
   :headers `(("Content-Type" . "application/json")
	      ("Access-Token" . ,pushbullet-api-key))
   :parser 'json-read
   :headers '(("Content-Type" . "application/json"))
   :error (cl-function
	   (lambda (&rest args &key error-thrown &allow-other-keys)
	     (message "Pushbullet error: %S" error-thrown)))))

(defun pb/send-region (title)
  "Pushes a region as an note.  TITLE is note's title."
  (interactive "sEnter title for this push:" )
  (let ((selection
	 (buffer-substring-no-properties (region-beginning) (region-end))))
    (unless (= (length selection) 0)
      (pb/push-item selection "note" title))))

(provide 'pushbullet)

;;; pushbullet.el ends here
