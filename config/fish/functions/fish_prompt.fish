function fish_prompt
    echo
    # Left pill cap (Flexoki light gray background color)
    set_color -o e6e4de
    echo -n ""
    set_color normal
    # Icon (Flexoki Black text on light gray background)
    set_color -o 100f0f
    set_color -b e6e4de
    echo -n "  "
    set_color normal
    # Path (Flexoki Black text on light gray background)
    set_color -o 100f0f
    set_color -b e6e4de
    echo -n (prompt_pwd)
    set_color normal
    # Right pill cap (Flexoki light gray background color)
    set_color -o e6e4de
    echo -n ""
    set_color normal
    # Prompt arrow (Flexoki Black)
    echo -n (set_color -o 100f0f)" ❯ "
end
