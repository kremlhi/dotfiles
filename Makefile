dotdirs = $(patsubst dot.%,$(HOME)/.%,$(wildcard dot.*/*))
dotfiles = $(patsubst dot.%,$(HOME)/.%,$(wildcard dot.*))

all: $(dotdirs) $(dotfiles)

$(HOME)/.%: dot.%
	mkdir -p $(dir $@)
	ln -s $(PWD)/$< $@

clean:
	$(RM) $(dotfiles) $(dotdirs)
