# tag: user.voicemacs
# -
# Buffers
# TODO: Fallbacks
(buffer | buff)$:
    user.emacs_switch_buffer()
(buffer | buff) <user.complex_phrase>$:
    user.emacs_switch_buffer()
    user.insert_complex(complex_phrase, "lowercase")
# FIXME: Not working reliably
buffers:
    user.emacs_command("helm-mini")
(buffer | buff | magic) {user.emacs_partial_buffer_names}$:
    user.emacs_partial_buffer_switch(emacs_partial_buffer_names)
(close | kill) (buffer | buff): user.emacs_command("kill-this-buffer")
(close | kill) other (buffer | buff):
    user.emacs_command("other-window")
    user.emacs_command("kill-this-buffer")
    user.emacs_command("other-window")
# Save & kill the buffer
(close | kill) disk:
    edit.save()
    user.emacs_command("kill-this-buffer")
(next | neck) (buffer | buff): user.emacs_command("next-buffer")
(last | larse) (buffer | buff): user.emacs_command("previous-buffer")
