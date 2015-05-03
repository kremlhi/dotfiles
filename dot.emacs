;;(setq debug-on-error nil)

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'auto-mode-alist '("emacs\\'" . emacs-lisp-mode))

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


;;;; pimpin my EMACS

(pcase window-system
  (`ns (set-background-color "black")
       (set-foreground-color "#eeeeee")
       (menu-bar-mode 1)
       (set-frame-font "Menlo 14"))
  (`x (global-set-key (kbd "C-z") nil)))

(setq display-time-24hr-format t)
(display-time-mode 1)

;; disable colour crap
(if (not (assoc 'tty-color-mode default-frame-alist))
    (push (cons 'tty-color-mode 'never) default-frame-alist))
(global-font-lock-mode -1)

;; SHUT UP!
(setq inhibit-default-init 1
      inhibit-startup-screen 1
      initial-scratch-message "")

(setq browse-url-generic-program (executable-find "sensible-browser")
      browse-url-browser-function 'browse-url-generic)

(setq-default cursor-type 'bar)
(blink-cursor-mode -1)

(set-face-attribute 'region nil :background "#4d4d4d")

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c L") 'org-insert-link-global)
(global-set-key (kbd "C-c o") 'org-open-at-point-global)

(setq org-log-done 'time)


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
(set-erlang-dir (erl-root))
(defun my-erlang-mode-hook ()
  (setq inferior-erlang-machine-options '("-sname" "emacs")))
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

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
  (setq tabs-width 4)
  (setq indent-tabs-mode t))
(add-hook 'python-mode-hook 'my-python-mode-hook)
(add-hook 'c++-mode-hook 'my-python-mode-hook)

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
(if (eq (getenv "USER") "emil")
  (setq rcirc-default-nick "emilh"
        rcirc-server-alist
        '(("irc.inet.tele.dk"
           :channels ("#dv" "#update"))
          ("irc.freenode.org"
           :channels ("#iccarus" "#erlang" "#emacs" "#bhyve" "#plan9" "#9front")))))

(require 'pomodoro)
(setq sounds '("/System/Library/Sounds/Glass.aiff"
               "/usr/share/sounds/ubuntu/stereo/phone-outgoing-busy.ogg"))
(setq sound (car (remove-if-not 'file-readable-p sounds)))
(if (not (executable-find pomodoro-sound-player))
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

(require 'emms-setup)
(emms-all)
(emms-default-players)
(require 'emms-player-mplayer)
(setq emms-source-file-default-directory "/skagul/music/skuld")
(require 'emms-history)
(emms-history-load)
(global-set-key (kbd "C-c +") 'emms-volume-mode-plus)
(global-set-key (kbd "C-c -") 'emms-volume-mode-minus)

(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")

(require 'w3m)
