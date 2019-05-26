umask ?= 077
destdir ?= $(HOME)
srcdir ?= $(patsubst $(destdir)/%,%,$(PWD))
dotdirs = $(patsubst dir.%,$(destdir)/.%,$(wildcard dir.*/*))
dotfiles = $(patsubst dot.%,$(destdir)/.%,$(wildcard dot.*))

all: $(dotdirs) $(dotfiles)

$(destdir)/.%: dir.%
	umask $(umask); mkdir -p $(dir $@)
	ln -s ../$(srcdir)/$< $@

$(destdir)/.%: dot.%
	ln -s $(srcdir)/$< $@

clean:
	$(RM) $(dotfiles) $(dotdirs)
