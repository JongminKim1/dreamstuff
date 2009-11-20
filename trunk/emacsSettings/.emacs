;;set frame title
(setq frame-title-format "emacs@%b")

;;use ibuffer instead of buffer switch
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "list buffers." t)



;;set the window position
(setq initial-frame-alist '((top . 0) (left . 700) (width . 80) (height . 30)))
;;Load CEDET
;; this CEDET is recompiled from the cvs source from sourceforge
(load-file "~/.emacs.d/cedet/common/cedet.el")

;;Enable EDE(Project management) features
;;(global-ede-mode 1)

;;company mode settings
(add-to-list 'load-path' "~/.emacs.d/company-mode")
(load-file "~/.emacs.d/company-mode/company.el")
(autoload 'company-mode "company" nil t)


;;config semantic
(setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")
(semantic-load-enable-code-helpers)
(global-semanticdb-minor-mode 1)
(semantic-add-system-include "/usr/local/include" 'c++-mode)
(semantic-add-system-include "/usr/local/qtsdk/qt/include" 'c++-mode)

;;configure the kbyboard
(require 'semantic-sb nil t)
(when (require 'semantic-ia nil t)
  (global-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
  )




;;(setq company-idle-delay t)

;;ecb support
;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/ecb")
;;(require 'ecb)




;;tempo-snippets support
(add-to-list 'load-path "~/.emacs.d/")
(require 'tempo-snippets)

;;code-mode support
(add-to-list 'load-path "~/emacs.d/")
(require 'doc-mode)
(add-hook 'c-mode-common-hook 'doc-mode)






;;for yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet-0.6.1c")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet-0.6.1c/snippets")




;;cscope
(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(require 'xcscope)

;; Xrefactory configuration part ;;
;; some Xrefactory defaults can be set here
;;(defvar xref-current-project nil) ;; can be also "my_project_name"
;;(defvar xref-key-binding 'global) ;; can be also 'local or 'none
;;(setq load-path (cons "/home/laijw/xref/emacs" load-path))
;;(setq exec-path (cons "/home/laijw/xref" exec-path)) 
;;(load "xrefactory")
;; end of Xrefactory configuration part ;;
;;(message "xrefactory loaded")


;;CMake support
;; add cmake listfile names to the mode list
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))
(autoload 'cmake-mode "~/.emacs.d/cmake-mode.el" t)

;;add support for uniquify, which can solve multiple CMakeList.txt<*> problem
(require 'uniquify)





;; ;;;;;;;;;;Settings for python
;;make sure pymacs and yasnippet get into your load path
(add-to-list 'load-path "~/.emacs.d")
(progn (cd "~/.emacs.d")
       (normal-top-level-add-subdirs-to-load-path)
       )

;;after download the auto-complete.el you configure it
(require 'ipython)
(require 'auto-complete)
(global-auto-complete-mode t)

(require 'yasnippet)

(autoload 'python-mode "python-mode" "python mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("pyhton" . python-mode))

;; ;;pymacs
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/pymacs/pymacs.el")
;; (load "~/.emacs.d/python/python-mode.el")

;; ;;load pymacs
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-exec "pymacs" nil t)
;; ;;Initialize Rope
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)



;;Auto-completion
;;Integrates:
;; 1) Rope
;; 2) yasnippet
;; all with autocomplete.el
(defun prefix-list-elements (list prefix)
  (let (value)
    (nreverse
     (dolist (element list value)
      (setq value (cons (format "%s%s" prefix element) value))))))
(defvar ac-source-rope
  '((candidates
     . (lambda ()
         (prefix-list-elements (rope-completions) ac-target))))
  "Source for Rope")
(defun ac-python-find ()
  "Python `ac-find-function'."
  (require 'thingatpt)
  (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
    (if (null symbol)
        (if (string= "." (buffer-substring (- (point) 1) (point)))
            (point)
          nil)
      symbol)))
(defun ac-python-candidate ()
  "Python `ac-candidates-function'"
  (let (candidates)
    (dolist (source ac-sources)
      (if (symbolp source)
          (setq source (symbol-value source)))
      (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
             (requires (cdr-safe (assq 'requires source)))
             cand)
        (if (or (null requires)
                (>= (length ac-target) requires))
            (setq cand
                  (delq nil
                        (mapcar (lambda (candidate)
                                  (propertize candidate 'source source))
                                (funcall (cdr (assq 'candidates source)))))))
        (if (and (> ac-limit 1)
                 (> (length cand) ac-limit))
            (setcdr (nthcdr (1- ac-limit) cand) nil))
        (setq candidates (append candidates cand))))
    (delete-dups candidates)))
(add-hook 'python-mode-hook
          (lambda ()
                 (auto-complete-mode 1)
                 (set (make-local-variable 'ac-sources)
                      (append ac-sources '(ac-source-rope) '(ac-source-yasnippet)))
                 (set (make-local-variable 'ac-find-function) 'ac-python-find)
                 (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
                 (set (make-local-variable 'ac-auto-start) nil)))
;;Ryan's python specific tab completion                                                                        
(defun ryan-python-tab ()
  ;; Try the following:                                                                                         
  ;; 1) Do a yasnippet expansion                                                                                
  ;; 2) Do a Rope code completion                                                                               
  ;; 3) Do an indent                                                                                            
  (interactive)
  (if (eql (ac-start) 0)
      (indent-for-tab-command)))

(defadvice ac-start (before advice-turn-on-auto-start activate)
  (set (make-local-variable 'ac-auto-start) t))
(defadvice ac-cleanup (after advice-turn-off-auto-start activate)
  (set (make-local-variable 'ac-auto-start) nil))

(define-key python-mode-map "\t" 'ryan-python-tab)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                         
;;; End Auto Completion                                                                                        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;auto syntax error hightlight
;; Auto Syntax Error Hightlight
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
(add-hook 'find-file-hook 'flymake-find-file-hook)
;;




