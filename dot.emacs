;;(setq debug-on-error nil)

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'auto-mode-alist '("emacs\\'" . emacs-lisp-mode))

;; from #emacs on freenode
(defun better-defaults ()
  (progn
    ;; deprecated rip :(
    ;; (iswitchb-mode 1)
    (icomplete-mode 1)
    ;; (ido-mode) ;sucks
    (setq ido-enable-flex-matching t)
    ;;(tool-bar-mode -1)
    (menu-bar-mode -1)
    ;;(scroll-bar-mode -1)
    (require 'uniquify)
    (setq-default indent-tabs-mode nil)
    (defalias 'yes-or-no-p 'y-or-n-p)
    (setq x-select-enable-clipboard t)
    (setq-default save-place t) (require 'saveplace)
    (global-set-key (kbd "M-/") 'hippie-expand)
    (global-set-key (kbd "C-x C-b") 'ibuffer)
    (setq apropos-do-all t)))
(better-defaults)
(setq-default tabs-width 8)


;;;; pimpin my EMACS

(setq display-time-24hr-format t)
(display-time-mode 1)

;; disable colour crap
(if (not (assoc 'tty-color-mode default-frame-alist))
    (push (cons 'tty-color-mode 'never) default-frame-alist))
(global-font-lock-mode 0)

;; SHUT UP!
(setq inhibit-default-init 1
      inhibit-startup-message 1
      initial-scratch-message "")

(setq browse-url-generic-program (executable-find "sensible-browser")
      browse-url-browser-function 'browse-url-generic)

(setq-default cursor-type 'bar)
(blink-cursor-mode 0)

(set-face-attribute 'region nil :background "#4d4d4d")


;;;; lang

(require 'cl)

(defun erl-root ()
  (shell-command-to-string
   "erl -noinput -eval 'io:format(os:getenv(\"ROOTDIR\")),halt().'"))

(defun set-erlang-dir (dir)
  (let ((bin-dir (expand-file-name "bin" dir))
        (tools-dirs (file-expand-wildcards
                     (concat dir "/lib/tools-*/emacs"))))
    (when tools-dirs
      (add-to-list 'load-path (car tools-dirs))
      (add-to-list 'exec-path bin-dir)
      (setq erlang-root-dir dir)
      (require 'erlang-start))))

(set-erlang-dir (erl-root))

(defun my-python-mode-hook ()
  (setq tabs-width 4)
  (setq indent-tabs-mode t))

(add-hook 'python-mode-hook 'my-python-mode-hook)

(c-add-style "openbsd" '("bsd"
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

(defun my-c++-mode-hook ()
  (setq tabs-width 4)
  (setq indent-tabs-mode t))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; cperl-mode is preferred to perl-mode
;; "Brevity is the soul of wit" <foo at acm.org>
(defalias 'perl-mode 'cperl-mode)



;;;; propaganda

(rcirc-track-minor-mode 1)

(setq rcirc-buffer-maximum-lines 1024
      rcirc-scroll-show-maximum-output nil
      ;;设置忽略的响应类型
      rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY" "MODE"))

(add-hook 'rcirc-mode-hook '(lambda () (rcirc-omit-mode))) ;默认打开忽略模式
(setq rcirc-track-minor-mode nil)                          ;关闭mode-line提示

(setq rcirc-server-alist
      '(("irc.inet.tele.dk"
         :channels ("#dv" "#update")
         :nick "emilh")
        ("irc.freenode.org"
         :channels ("#iccarus" "#erlang" "#emacs" "#bhyve" "#plan9" "#9front")
         :nick "emilh")))

(setq rcirc-log-flag t)


(require 'pomodoro)
(setq sounds '("/System/Library/Sounds/Glass.aiff"
               "/usr/share/sounds/ubuntu/stereo/phone-outgoing-busy.ogg"))
(setq sound (car (remove-if-not 'file-readable-p sounds)))
(when (not (locate-file "mplayer" exec-path))
  (setq pomodoro-sound-player "afplay"))

(setq pomodoro-break-start-sound sound
      pomodoro-work-start-sound sound
      pomodoro-time-format "%m"
      pomodoro-show-number t)
(pomodoro-add-to-mode-line)


(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; (setq emms-player-list '(emms-player-alsaplayer))
(require 'emms-setup)
(emms-all)
(emms-default-players)
(require 'emms-player-mplayer)
(setq emms-source-file-default-directory "/skagul/music/skuld"
      emms-playlist-buffer-name "*Music*")
(require 'emms-history)
(emms-history-load)
(global-set-key (kbd "C-c +") 'emms-volume-mode-plus)
(global-set-key (kbd "C-c -") 'emms-volume-mode-minus)

;; M-x emms-streams

(require 'magit)

(setq magit-last-seen-setup-instructions "1.4.0")

(require 'w3m)
