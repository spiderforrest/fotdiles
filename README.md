## spider's config files

Hi there! Here are my dotfiles, not much to say there. Software:

- [Bedrock Linux](https://bedrocklinux.org)-A meta distribution that manages assembling a system of parts from multiple distributions. Below are the actual distributions I use as strata, roughly ordered by usage.
    - [void-musl/void](https://voidlinux.org)-I prefer void [musl](https://musl.libc.org) for most system components, but with the [glibc](https://www.gnu.org/software/libc/) dependence of some applications I must use, I fall back to fetching packages from void-glibc, then archlinux, and so on.
    - [Arch](https://archlinux.org)-btw. (mostly useful for the AUR and compatibility)
    - [Alpine](https://alpinelinux.org)-honestly I mostly use alpine to test things.
    - [Fedora](https://fedoraproject.org)-mostly for net facing servers that need security.
    - [Gentoo](https://gentoo.org)-every once in a while I need the portage tools to help me hack together some code ripped from github. Not often, but it's a godsend when I do.
    - [Ubuntu](https://ubuntu.com)-sometimes you need some proprietary garbage to Just Work, and usually this is your best shot. After the AUR.
- [Neovim](https://neovim.io)-hey emacs users can we call the war off and go beat up vscode please.
- [AwesomeWM](https://awesomewm.org)-Awesome is a framework, not an application to configure, and my 'configs' are expansive. Lua.
- [WezTerm](https://wezfurlong.org/wezterm)-term.
- [Qutebrowser](https://qutebrowser.org)-modal browser.
- [Chore](https://github.com/paradigm/chore)-cli todo list by the guy who did bedrock. It's nice.
- [Redshift](https://github.com/jonls/redshift)-my eyes. Sometime when I'm less broke I'll get an e-ink monitor.
- [Ly](https://github.com/fairyglade/ly)-display manager.
- [Flameshot](https://flameshot.org)-screenshots.
- [Font Manager](https://github.com/FontManager/font-manager)-this bad boy makes fonts easy as hell, basically a must-have.
- [BTOP](https://github.com/aristocratos/btop)-process manager. she cute.
- [Gajim](https://gajim.org)-mostly actually use [profanity](https://profanity-im.github.io/) but gui sometimes. if you're reading this you're probably in my xmpp server, but if not you're invited, contact me.
- [Numen](https://git.sr.ht/~geb/numen)-a voice input tool to simulate inputs, dictate, or run scripts.
- [Picom](https://github.com/yshui/picom)-honestly I'm currently just using this for transparent borders.
- [Xfce4 Mime Settings](https://docs.xfce.org/xfce/xfce4-settings/4.14/mime)-big thanks to xfce for having so many useful modular components. I just use this to set [mime](https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html) and don't touch it.
- [Quantum Mechanical Keyboards](https://github.com/qmk_firmware/qmk_firmware)-honorable mention. Configs are on [my fork of QMK], I use the [Lily58](https://github.com/kata0510/Lily58).

I have unused former configs for:
- [i3wm](https://i3wm.org)-over time got more and more annoyed at restrictions. I realize how far off the deep end I am.
- [Alacritty](https://alacritty.org)-term.
