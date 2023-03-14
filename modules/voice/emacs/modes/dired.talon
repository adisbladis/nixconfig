# tag: user.emacs
user.emacs-major-mode: dired-mode
-
move <number>: user.emacs_dired_highlight(number)
(open | follow) [<number>]:
    user.emacs_dired_command("dired-find-file", number or 0)
[(open | follow)] other [<number>]:
    user.emacs_dired_command("dired-find-file-other-window", number or 0)
action(user.rename): user.emacs_dired_command("dired-do-rename", 0)
(rename | move) [<number>]:
    user.emacs_dired_command("dired-do-rename", number or 0)

# Use "flag" instead of "mark" because we may also want to mark text.
flag [<number>]:
    user.emacs_dired_command("dired-mark", number or 0)
flag all:
    user.emacs_command("dired-mark-files-regexp")
    key("enter")
flag (regex | regexp): user.emacs_command("dired-mark-files-regexp")
unflag [<number>]:
    user.emacs_dired_command("dired-unmark", number or 0)
unflag all: user.emacs_command("dired-unmark-all-marks")

copy [file] [<number>]:
    user.emacs_dired_command("dired-do-copy", number or 0)
flag [to] (delete | kill) [<number>]:
    user.emacs_dired_command("dired-flag-file-deletion", number or 0)
(expunge | (delete | kill) flagged): user.emacs_command("dired-do-delete")
(delete | kill) [file] [<number>]:
    user.emacs_command("dired-unmark-all-marks")
    user.emacs_dired_command("dired-do-delete", number or 0)



# TODO: Maybe allow the word insert? Clashes with the key.
expand [<number>]:
    user.emacs_dired_command("dired-maybe-insert-subdir", number or 0)
shell [<number>]:
    user.emacs_dired_command("dired-do-shell-command", number or 0)

# TODO: To extract
parent: user.emacs_command("dired-up-directory")
(create | new) durr: user.emacs_command("dired-create-directory")
[toggle] (sort | sorting): user.emacs_command("dired-sort-toggle-or-edit")
# TODO: Maybe pull out into Voicemacs?
(create | new) file: user.emacs_command("jcaw-dired-create-file")
refresh: user.emacs_command("revert-buffer")
