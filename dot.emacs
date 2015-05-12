;; -*- mode: emacs-lisp -*-

(add-to-list 'load-path "~/.emacs.d/lisp")

;; put your private parts in ~/.emacs.d/lisp/priv-${USER}.el
(let ((lib (concat "priv-" (getenv "USER"))))
  (when (locate-library lib)
    (load lib)))


;;;; pimpin my EMACS

;; from #emacs on freenode
(defun better-defaults ()
  ;; (iswitchb-mode 1) ;deprecated, rip :(
  (ido-mode 1) ;sucks
  ;; (icomplete-mode 1) ;sucks even more
  (setq ido-enable-flex-matching t)
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))
  (menu-bar-mode -1)
  (require 'uniquify)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq-default save-place t) (require 'saveplace)
  (global-set-key (kbd "M-/") 'hippie-expand)
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  (setq-default indent-tabs-mode nil)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain
        x-select-enable-clipboard t
        x-select-enable-primary t
        apropos-do-all t))
(better-defaults)

(when (eq system-type 'darwin)
  (menu-bar-mode 1)
  (add-to-list 'default-frame-alist '(background-color . "black"))
  (add-to-list 'default-frame-alist '(foreground-color . "#eeeeee"))
  (add-to-list 'default-frame-alist '(font . "Menlo 13"))
  (add-to-list 'default-frame-alist '(height . 47))
  (set-face-attribute 'region nil :background "#4d4d4d")
  (setq mac-option-key-is-meta nil
        mac-command-key-is-meta t
        mac-command-modifier 'meta
        mac-option-modifier nil))

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/trash"))
      delete-old-versions t
      kept-new-versions 6
      version-control t)

;; disable colour crap
(unless (assoc 'tty-color-mode default-frame-alist)
    (push (cons 'tty-color-mode 'never) default-frame-alist))
(global-font-lock-mode -1)

;; SHUT UP!
(setq inhibit-default-init t
      inhibit-startup-screen t
      initial-scratch-message "")

(setq-default cursor-type 'bar)
(blink-cursor-mode -1)

(setq org-log-done 'time
      default-input-method "swedish-postfix" ;C-\
      browse-url-browser-function 'eww-browse-url
      ring-bell-function 'ignore)

(global-set-key (kbd "C-c +") 'emms-volume-mode-plus)
(global-set-key (kbd "C-c -") 'emms-volume-mode-minus)
(global-set-key (kbd "C-c L") 'org-insert-link-global)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c o") 'org-open-at-point-global)
(global-set-key (kbd "M-g b") 'magit-blame-mode)
(global-set-key (kbd "M-g o") 'magit-show)
(global-set-key (kbd "M-g s") 'magit-status)


;;;; lang

(require 'cl)

(defun erl-root ()
  (or (getenv "OTP_ROOT")
      (shell-command-to-string
       "erl -noinput -eval 'io:format(os:getenv(\"ROOTDIR\")),halt().'")))

(defun cond-load-distel (dir)
  (when (file-exists-p dir)
    (add-to-list 'load-path dir)
    (require 'distel)
    (distel-setup)))

(defun set-erlang-dir (dir)
  (let ((bin-dir (expand-file-name "bin" dir))
        (tools-dirs (file-expand-wildcards
                     (concat dir "/lib/tools-*/emacs"))))
    (when tools-dirs
      (add-to-list 'load-path (car tools-dirs))
      (add-to-list 'exec-path bin-dir)
      (setq erlang-root-dir dir)
      (require 'erlang-start)
      (cond-load-distel (concat (getenv "HOMESW") "/share/distel/elisp")))))

(defun my-erlang-mode-hook ()
  (setq inferior-erlang-machine-options '("-sname" "emacs")))

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

(set-erlang-dir (erl-root))

(c-add-style "openbsd"
             '("bsd"
               (indent-tabs-mode . t)
               (defun-block-intro . 8)
               (statement-block-intro . 8)
               (statement-case-intro . 8)
               (substatement-open . 4)
               (substatement . 8)
               (arglist-cont-nonempty . 4)
               (inclass . 8)
               (knr-argdecl-intro . 8)))
(setq c-default-style "openbsd")

(defun my-python-mode-hook ()
  (setq indent-tabs-mode t
        tab-width 4
        python-indent 4))

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

(add-hook 'rcirc-mode-hook '(lambda () (rcirc-omit-mode))) ;默认打开忽略模式

(rcirc-track-minor-mode 1)

(setq rcirc-buffer-maximum-lines 1024
      rcirc-scroll-show-maximum-output nil
      ;;设置忽略的响应类型
      rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY" "MODE")
      rcirc-log-flag t)

(require 'epg-config)

(setq mml2015-use 'epg
      mml2015-verbose t
      mml2015-encrypt-to-self t
      mml2015-cache-passphrase t
      mml2015-passphrase-cache-expiry '36000
      epg-debug t)

(require 'pomodoro)

(setq sounds '("/System/Library/Sounds/Glass.aiff"
               "/usr/share/sounds/ubuntu/stereo/phone-outgoing-busy.ogg"))

(setq sound (car (remove-if-not 'file-readable-p sounds)))

(unless (executable-find pomodoro-sound-player)
  (setq pomodoro-sound-player "afplay"))

(setq pomodoro-break-start-sound sound
      pomodoro-work-start-sound sound
      pomodoro-time-format "%m"
      pomodoro-show-number t)

(pomodoro-add-to-mode-line)

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;; (mapcar 'package-install '(emms magit))

(require 'emms-setup)

(emms-all)
(emms-default-players)

(require 'magit)
(magit-auto-revert-mode -1)
(setq magit-last-seen-setup-instructions "1.4.0")

(require 'mu4e)
(when (locate-library "mu4e-contrib") ;no contrib in mu4e 0.9.9.5
  (require 'mu4e-contrib)
  (setq mu4e-html2text-command 'mu4e-shr2text))

(require 'org-mu4e)

(setq shr-inhibit-decoration t
      mu4e-view-prefer-html t ;people...
      mu4e-get-mail-command "offlineimap"
      mu4e-update-interval (* 5 60)
      mu4e-headers-date-format "%F %T"
      mail-user-agent 'mu4e-user-agent
      mu4e-compose-signature ""
      message-signature nil
      mu4e-org-contacts-file  "~/org/contacts.org"
      smtpmail-stream-type 'ssl
      send-mail-function 'smtpmail-send-it)

(add-to-list 'mu4e-headers-actions
             '("org-contact-add" ?o mu4e-action-add-org-contact) t)

(add-to-list 'mu4e-view-actions
             '("org-contact-add" ?o mu4e-action-add-org-contact) t)
