(setq make-backup-files nil)

(require 'org)

(require 'ob-shell)

(defun my-org-confirm-babel-evaluate (lang body)
  "Given LANG return BODY."
  (not (or (string= lang "bash"))))

(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

(advice-add 'org-md-headline :override
            (lambda (headline contents info)
              (unless (org-element-property :footnote-section-p headline)
                (let* ((level (+ (org-export-get-relative-level headline info) 1))
                       (title (org-export-data (org-element-property :title headline) info))
                       (todo (and (plist-get info :with-todo-keywords)
                                  (let ((todo (org-element-property :todo-keyword
                                                                    headline)))
                                    (and todo (concat (org-export-data todo info) " ")))))
                       (tags (and (plist-get info :with-tags)
                                  (let ((tag-list (org-export-get-tags headline info)))
                                    (and tag-list
                                         (format "     :%s:"
                                                 (mapconcat 'identity tag-list ":"))))))
                       (priority
                        (and (plist-get info :with-priority)
                             (let ((char (org-element-property :priority headline)))
                               (and char (format "[#%c] " char)))))
                       (anchor
                        (and (plist-get info :with-toc)
                             (format "<a id=\"%s\"></a>"
                                     (or (org-element-property :CUSTOM_ID headline)
                                         (org-export-get-reference headline info)))))
                       ;; Headline text without tags.
                       (heading (concat todo priority title))
                       (style (plist-get info :md-headline-style)))
                  (cond
                   ;; Cannot create a headline.  Fall-back to a list.
                                        ;((or (org-export-low-level-p headline info)
                   ((and (org-export-low-level-p headline info)
                         (not (memq style '(atx setext)))
                         (and (eq style 'atx) (> level 6))
                         (and (eq style 'setext) (> level 2)))
                    (let ((bullet
                           (if (not (org-export-numbered-headline-p headline info)) "-"
                             (concat (number-to-string
                                      (car (last (org-export-get-headline-number
                                                  headline info))))
                                     "."))))

                      (concat bullet (make-string (- 4 (length bullet)) ?\s) heading tags
                              "\n\n"
                              (and contents
                                   (replace-regexp-in-string "^" "    " contents)))))
                   ;; Use "Setext" style.
                   ((eq style 'setext)
                    (concat heading tags anchor "\n"
                            (make-string (length heading) (if (= level 1) ?= ?-))
                            "\n\n"
                            contents))
                   ;; Use "atx" style.
                   (t (concat (make-string level ?#) " " heading tags anchor "\n\n"
                              contents)))))))

(advice-add 'org-md-example-block :override
            (lambda (example-block contents info)
              (let ((lang (org-element-property :language example-block)))
                (concat "{% highlight "
                        (or (if (equal lang "ipython") "python" lang)
                            (org-element-property :switches example-block)
                            "plaintext")
                        " %}\n"
                        (org-export-format-code-default example-block info)
                        "{% endhighlight %}"))))

(find-file (car argv))

(org-md-export-as-markdown)

(write-file (cadr argv))
