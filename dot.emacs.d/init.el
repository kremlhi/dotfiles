;; -*- mode: emacs-lisp -*-

(add-to-list 'load-path "~/.emacs.d/lisp")

;; put your private parts in ~/.emacs.d/lisp/priv-${USER}.el
(let ((lib (concat "priv-" user-login-name)))
  (when (locate-library lib)
    (load lib)))


;;;; pimpin my EMACS

;; from #emacs on freenode
(defun better-defaults ()
  ;; (iswitchb-mode 1) ;deprecated, rip :(
  (ido-mode 'buffer) ;sucks
  ;; (icomplete-mode 1) ;sucks even more
  (setq ido-enable-flex-matching t)
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))
  (menu-bar-mode -1)
  (require 'uniquify)
  (require 'ffap)
  (setq ffap-lax-url nil) ;don't match filenames with @ as email addresses
  (ffap-bindings)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq-default save-place-mode t) (require 'saveplace)
  (global-set-key (kbd "M-/") 'hippie-expand)
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  (setq-default indent-tabs-mode nil)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain
        x-select-enable-clipboard t
        x-select-enable-primary t
        apropos-do-all t))
(better-defaults)

(defun add-list-to-list (name lst)
  (mapcar (lambda (x) (add-to-list name x)) lst))

(when (eq system-type 'darwin)
  (menu-bar-mode 1)
  (global-set-key (kbd "C-z") nil) ;this is braindead
  (add-to-list 'default-frame-alist '(font . "Menlo 14"))
  (add-to-list 'default-frame-alist '(height . 44))
  (add-to-list 'default-frame-alist '(background-color . "black"))
  (add-to-list 'default-frame-alist '(foreground-color . "#eeeeee"))
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . nil))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))

;; disable colour crap
(unless (assoc 'tty-color-mode default-frame-alist)
    (push (cons 'tty-color-mode 'never) default-frame-alist))
(global-font-lock-mode -1)

(setq inhibit-default-init t ;SHUT UP!
      inhibit-startup-screen t
      initial-scratch-message ""
      org-log-done 'time
      ido-default-buffer-method 'selected-window
      default-input-method "swedish-postfix" ;C-\
      browse-url-browser-function 'eww-browse-url
      ring-bell-function 'ignore
      backup-directory-alist '(("." . "~/.emacs.d/trash")) ;do not litter *~
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      version-control t
      shr-inhibit-decoration t ;makes my eyes bleed...... ,(
      line-number-display-limit nil)

(setq-default cursor-type 'bar)
(blink-cursor-mode -1)

;;(add-hook 'before-save-hook 'delete-trailing-whitespace) ;to please git
(setq split-width-threshold nil) ;do not split horizontally

;; EMACS get slow and dorky with too big buffers
(setq comint-buffer-maximum-size 10240)
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)
;; or long lines
(setq-default bidi-display-reordering nil)

;; the culprit of https://debbugs.gnu.org/cgi/bugreport.cgi?bug=20349 ?
(remove-hook 'comint-output-filter-functions 'ansi-color-process-output)
;; option: M-x comint-send-invisible (M-x c-inv)
;(remove-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

(defun my-comint-mode-hook ()
  (setq 
   ;;comint-process-echoes t            ;or shell will echo everything twice
                                        ;disabled for now, since shell hangs
   ;;from https://stackoverflow.com/questions/26985772/fast-emacs-shell-mode
   comint-move-point-for-output nil
   comint-scroll-show-maximum-output nil)
;  (buffer-disable-undo)
)
(add-hook 'comint-mode-hook 'my-comint-mode-hook)

;;(global-set-key (kbd "C-h") 'delete-backward-char) ;deal with it B-)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x |") 'plumb)
(global-set-key (kbd "s-\"") 'previous-multiframe-window)

;;;; lang

(require 'cl)

(defun erl-root ()
  (or (getenv "OTP_ROOT")
      (shell-command-to-string
       (format "erl -boot start_clean -noinput -eval '%s'"
               "io:format(\"~s\",[os:getenv(\"ROOTDIR\")]),halt()."))))

(defun cond-load-distel (dir)
  (when (file-exists-p dir)
    (add-to-list 'load-path dir)
    (require 'distel)
    (distel-setup)))

;; (add-hook 'after-init-hook 'my-after-init-hook)
;; (defun my-after-init-hook ()
;;   (require 'edts-start))

(defun set-erlang-dir (dir)
  (let ((bin-dir (expand-file-name "bin" dir))
        (tools-dirs (file-expand-wildcards
                     (concat dir "/lib/tools-*/emacs"))))
    (when tools-dirs
      (add-to-list 'load-path (car tools-dirs))
      (add-to-list 'exec-path bin-dir)
      (setq erlang-root-dir dir)
      ;; crapOS https://github.com/elixir-lang/elixir/issues/3955
      ;; TL;DR add 127.0.0.1 <hostname> to /etc/hosts
      (setq inferior-erlang-machine-options '("-sname" "emacs"))
      (require 'erlang-start)
      (cond-load-distel (concat (getenv "HOMESW") "/share/distel/elisp"))
      )))
(set-erlang-dir (erl-root))

(c-add-style "acme" '("bsd"
                         (c-basic-offset . 4)
                         (indent-tabs-mode . nil)
                         (defun-block-intro . 4)
                         (statement-block-intro . 4)
                         (statement-case-intro . 4)
                         (substatement-open . 4)
                         (substatement . 4)
                         (arglist-cont-nonempty . 4)
                         (inclass . 4)
                         (knr-argdecl-intro . 4)))
(setq c-default-style "acme")

(defun my-python-mode-hook ()
  (setq indent-tabs-mode nil
        tab-width 4
        python-indent-offset 4))
(add-hook 'python-mode-hook 'my-python-mode-hook)

(defun my-sh-mode-hook ()
  (setq sh-indentation 4
        sh-basic-offset 4
        indent-tabs-mode nil))
(add-hook 'sh-mode-hook 'my-sh-mode-hook)

;; cperl-mode is preferred to perl-mode
;; "Brevity is the soul of wit" <foo at acm.org>
(defalias 'perl-mode 'cperl-mode)


;;;; propaganda

(setq rcirc-buffer-maximum-lines 1024
      rcirc-scroll-show-maximum-output nil
      rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY" "MODE")
      rcirc-log-flag t
      rcirc-decode-coding-system 'undecided) ;until 2038 when vol knows better
(add-hook 'rcirc-mode-hook 'rcirc-omit-mode) ;默认打开忽略模式
(rcirc-track-minor-mode 1)

(require 'epg-config)
(setq mml2015-use 'epg
      mml2015-verbose t
      mml2015-encrypt-to-self t
      mml2015-cache-passphrase t
      mml2015-passphrase-cache-expiry '36000
      epg-debug t)

(require 'pomodoro) ;located in ~/.emacs.d/lisp/
(setq pomodoro-time-format "%m"
      pomodoro-show-number t)
(pomodoro-add-to-mode-line)

(require 'package)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://melpa.org/packages/"))

(package-initialize)
;; (mapcar 'package-install '(emms magit))

;; (require 'org-jira)
;; (setq jiralib-url "https://jira-eng-gpk3.cisco.com/jira")

(require 'emms-setup)
(emms-all)
(emms-default-players)

(require 'magit)
(magit-auto-revert-mode -1)
(setq magit-last-seen-setup-instructions "1.4.0")

(defalias 'xml-mode 'sgml-xml-mode)
(flyspell-mode -1)

;; (autoload 'yang-mode "yang-mode" "Major mode for editing YANG modules." t)
;; (add-to-list 'auto-mode-alist '("\\.yang$" . yang-mode))
(require 'yang-mode)
(require 'lux-mode)

(defun show-onelevel ()
  "show entry and children in outline mode"
  (interactive)
  (show-entry)
  (show-children))

(defun my-outline-bindings ()
  "sets shortcut bindings for outline minor mode"
  (interactive)
  (local-set-key [?\C-,] 'hide-body)
  (local-set-key [?\C-.] 'show-all)
  (local-set-key [C-up] 'outline-previous-visible-heading)
  (local-set-key [C-down] 'outline-next-visible-heading)
  (local-set-key [C-left] 'hide-subtree)
  (local-set-key [C-right] 'show-onelevel)
  (local-set-key [M-up] 'outline-backward-same-level)
  (local-set-key [M-down] 'outline-forward-same-level)
  (local-set-key [M-left] 'hide-subtree)
  (local-set-key [M-right] 'show-subtree))

(add-hook 'outline-minor-mode-hook 'my-outline-bindings)

(defconst sort-of-yang-identifier-regexp "[-a-zA-Z0-9_\\.:]*")
(add-hook
 'yang-mode-hook
 (lambda ()
   (setq c-basic-offset 2)
   (outline-minor-mode)
   (setq outline-regexp
         (concat "^ *" sort-of-yang-identifier-regexp " *"
                 sort-of-yang-identifier-regexp
                 " *{"))))

(defun my-thing-at-point (thing) ;thing is ignored
  (if (use-region-p)
      (buffer-substring (region-beginning) (region-end))
    (let ((thing-at-point-file-name-chars "-_[:alnum:]#:@"))
      (thing-at-point 'filename))))

(defun plumb (arg)
  (interactive
   (let* ((default (my-thing-at-point 'filename))
          (prompt (if (stringp default)
                      (format "plumb (default %s): " default)
                    "plumb: "))
          (val (read-string prompt nil nil (list default))))
     (list val)))
  (shell-command (format "plumb '%s'" arg)))


;; https://www.emacswiki.org/emacs/FindFileAtPoint - thanks DanielPoersch
(defvar ffap-file-at-point-line-number nil
  "Variable to hold line number from the last `ffap-file-at-point' call.")

(defadvice ffap-file-at-point (after ffap-store-line-number activate)
  "Search `ffap-string-at-point' for a line number pattern and
save it in `ffap-file-at-point-line-number' variable."
  (let* ((string (ffap-string-at-point));string/name definition copied from
                                        ;`ffap-string-at-point'
         (name
          (or (condition-case nil
                  (and (not (string-match "//" string)) ; foo.com://bar
                       (substitute-in-file-name string))
                (error nil))
              string))
         (line-number-string 
          (and (string-match ":[0-9]+" name)
               (substring name (1+ (match-beginning 0)) (match-end 0))))
         (line-number
          (and line-number-string
               (string-to-number line-number-string))))
    (if (and line-number (> line-number 0)) 
        (setq ffap-file-at-point-line-number line-number)
      (setq ffap-file-at-point-line-number nil))))

(defadvice find-file-at-point (after ffap-goto-line-number activate)
  "If `ffap-file-at-point-line-number' is non-nil goto this line."
  (when ffap-file-at-point-line-number
    (goto-char (point-min))
    (forward-line (1- ffap-file-at-point-line-number))
    (setq ffap-file-at-point-line-number nil)))

(add-list-to-list
 'load-path
 (list (concat (getenv "tailf") "/devel_support/lib/emacs")
       (concat (getenv "tailf") "/devel_support/lib/emacs/tailfsnippets/yasnippet")))

(when (locate-library "tail-f")
  (load "tail-f")
  (require 'yasnippet)
  (yas-global-mode 1))

;; (require 'mu4e)
;; (require 'org-mu4e)
;; (when (locate-library "mu4e-contrib") ;no contrib in mu4e 0.9.9.5
;;   (require 'mu4e-contrib)
;;   (setq mu4e-html2text-command 'mu4e-shr2text))
;; (setq mu4e-view-prefer-html t ;people...
;;       mu4e-get-mail-command "offlineimap"
;;       mu4e-update-interval (* 5 60)
;;       mu4e-headers-date-format "%F %T"
;;       mail-user-agent 'mu4e-user-agent
;;       mu4e-compose-signature ""
;;       message-signature nil
;;       mu4e-org-contacts-file  "~/org/contacts.org"
;;       smtpmail-stream-type 'ssl
;;       send-mail-function 'smtpmail-send-it)
;; (add-to-list 'mu4e-headers-actions
;;              '("org-contact-add" ?o mu4e-action-add-org-contact) t)
;; (add-to-list 'mu4e-view-actions
;;              '("org-contact-add" ?o mu4e-action-add-org-contact) t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(jabber-invalid-certificate-servers (quote ("cisco.com")))
 '(jiralib-url "https://jira-eng-gpk3.cisco.com/jira")
 '(package-selected-packages
   (quote
    (oauth2 password-store org-jira vdirel yasnippet xml-rpc w3m vlf magit jabber emms edts))))

;; comes from jabber-socks-query-all-proxies
;; https://cisco.jiveon.com/docs/DOC-1355817
(setq jabber-socks5-proxies-data
      '(("proxy.isj3.webex.com"
         (streamhost
          ((host . "isj3jft601-s.webexconnect.com")
           (jid . "proxy.isj3.webex.com")
           (port . "1080"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
