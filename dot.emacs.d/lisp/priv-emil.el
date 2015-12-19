(setq epg-user-id "E9DA81A7"

      user-mail-address "emil@update.uu.se"
      user-full-name "Emil Holmström"
      smtpmail-smtp-user "emil.holmstrom"
      smtpmail-local-domain "update.uu.se"
      smtpmail-smtp-server "mail.google.com"
      smtpmail-smtp-service 465

      rcirc-default-nick "emilh"
      rcirc-server-alist
      '(("irc.inet.tele.dk"
         :channels ("#dv" "#update"))
        ("irc.freenode.org"
         :channels ("#iccarus" "#erlang" "#emacs" "#bhyve" "#plan9" "#9front")))

      emms-source-file-default-directory "/skagul/music/skuld")

(provide 'priv-emil)
