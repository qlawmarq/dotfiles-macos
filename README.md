# What's this about?

Dotfiles for Mac.

## Before use (when setting up the PC from zero)

If you have a brand new PC, you'll need setup your SSH key first.

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

1. Generate a new SSH key

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
```

2. Update your SSH config

```sh
touch ~/.ssh/config
```

Copy below and paste it in `~/.ssh/config`.

```txt
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

3. Add your new SSH key to your GitHub account.

```sh
pbcopy < ~/.ssh/id_ed25519.pub
```

Click `New SSH key` and paste it in your GitHub.

https://github.com/settings/keys

## How to use this

1. Clone this files and place it in home dir.
2. Use `brew.sh` and install [Homebrew](https://brew.sh/) and other software
3. (Optional) Install `anyenv` and other environment managers (`nodenv` and `goenv`)
