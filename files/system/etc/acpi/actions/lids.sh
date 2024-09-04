# Ref: https://unix.stackexchange.com/questions/678609/how-to-disable-fingerprint-authentication-when-laptop-lid-is-closed
state=$(echo "$1" | cut -d " " -f 3)
case "$state" in
    open)
        sudo authselect enable-feature with-fingerprint
        ;;
    close)
        sudo authselect disable-feature with-fingerprint
        ;;
    *)
        # panic: not a state I know about!
esac
