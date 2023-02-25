function update
    flatpak update
    rustup update
    distrobox enter arch -- yay -Syu --noconfirm --answerclean y --answeredit n --answerdiff n --answerupgrade y --cleanafter
    rpm-ostree update
end