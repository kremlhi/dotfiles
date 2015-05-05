(setq epg-user-id "E9DA81A7"

      smtpmail-smtp-user "emil.holmstrom"
      smtpmail-local-domain "dektech.com.au"
      smtpmail-smtp-server "mail.dektech.com.au"
      smtpmail-smtp-service 465
      smtpmail-stream-type 'ssl

      rcirc-default-nick "emilh"
      rcirc-server-alist
      '(("irc.inet.tele.dk"
         :channels ("#dv" "#update"))
        ("irc.freenode.org"
         :channels ("#iccarus" "#erlang" "#emacs" "#bhyve" "#plan9" "#9front")))

      emms-source-file-default-directory "/skagul/music/skuld")

(provide 'priv-emil)
