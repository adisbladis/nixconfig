# HACK: Tag extraction like this doesn't override OS based stuff, so manually
#   specify it.
os: windows
os: linux
os: mac
-

# "c-g" is the interrupt command. It's hardcoded in C - can't remap it.
cancel: key(ctrl-g)
# Triple esc will get us out of any context
# TODO: Settle on one of these
(reset | rescue): key(esc esc esc)
prefix: user.emacs_prefix()
prefix <number>: user.emacs_prefix(number)
prefix dash: user.emacs_prefix("-")
meta: key(alt-x)
meta <user.complex_phrase>$:
    key(alt-x)
    user.insert_complex(complex_phrase, "lowercase")

# Window management
other [(window | win)]: user.emacs_command("other-window")
ace [(window | win)]: user.emacs_command("ace-window")
(window | win) (close | kill): user.emacs_command("delete-window")
single: user.emacs_command("delete-other-windows")
(close | kill) other (windows | wins): user.emacs_command("delete-other-windows")
balance [(windows | wins)]: user.emacs_command("balance-windows")
win redo: user.emacs_command("winner-redo")
win undo: user.emacs_command("winner-undo")
tile vert: user.emacs_command("split-window-right")
tile hori: user.emacs_command("split-window-below")

(dired | dyad | folder): user.emacs_command("dired-jump")
(dired | dyad | folder) other: user.emacs_command("dired-jump-other-window")

open: user.emacs_command("helm-find-files")
exec: user.emacs_command("adis-run")

reflow:
    user.emacs_command("end-of-line")
    user.emacs_command("fill-paragraph")

save: user.emacs_command("save-buffer")
undo: user.emacs_command("undo-fu-only-undo")
fuck: user.emacs_command("undo-fu-only-undo")
redo: user.emacs_command("undo-fu-only-redo")

vterm: user.emacs_command("adis-terminal")

go: key("enter")

# Toggle line numbers display
tlines: user.emacs_command("display-line-numbers-mode")

vol <number>: user.emacs_prefix_command("volume-set", number)
light <number>: user.emacs_prefix_command("brightness-set", number)

# Scrolling
# cursor top [<number>]:
#     user.emacs_prefix_command("evil-scroll-line-to-top", number or 0)
cursor top [<number>]: user.emacs_prefix_command("recenter", number or 1)
# cursor bottom [<number>]:
#     user.emacs_prefix_command("evil-scroll-line-to-bottom", number or 0)
cursor bottom [<number>]:
    pos = number or 1
    pos = -1 * pos
    user.emacs_prefix_command("recenter", pos)
cursor (midd`le | center) [<number>]:
    user.emacs_prefix_command("evil-scroll-line-to-center", number or 0)
line [<number>]: user.emacs_prefix_command("goto-line", number)
# TODO: Scroll up/down by single lines

[show] kill ring: user.emacs_command("helm-show-kill-ring")

highlight:               user.emacs_command("highlight-symbol-at-point")
(unhighlight | unlight): user.emacs_command("unhighlight-regexp")

(next | neck) error:  user.next_error()
(last | larse) error: user.previous_error()

(rectangle | rect): user.emacs_command("rectangle-mark-mode")

# Double `ctrl-c` means "submit", but the specific command varies based on
# context. Easier to just bind the keypress than try and bind each
# implementation.
submit:  key(ctrl-c ctrl-c)
discard: key(ctrl-c ctrl-k)


# Kill to a specific character
zap <user.character> [<number>]:
    user.emacs_prefix_command("zap-up-to-char", number or 1)
    key(character)
zapley <user.character> [<number>]:
    user.emacs_prefix_command("zap-to-char", number or 1)
    key(character)
bazap <user.character> [<number>]:
    number = number or 1
    user.emacs_prefix_command("zap-up-to-char", number * -1)
    key(character)
bazapley <user.character> [<number>]:
    number = number or 1
    user.emacs_prefix_command("zap-to-char", number * -1)
    key(character)
