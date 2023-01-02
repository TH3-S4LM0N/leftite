prep_sb() {
    mkdir -p ./silverblue/usr/share/leftos
    cp -r ./configs ./silverblue/usr/share/leftos
}

while [[ "$1" ]]; do
    case $1 in
        "prep_sb") prep_sb ;;
    esac

    shift
done