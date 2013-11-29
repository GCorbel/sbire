# Sbire

"Sbire" is the French word for henchman. Sbire is program which is capable to listen what you said and execute the command associated.

## Installation

Linux :

    sudo apt-get install sox notify-osd ruby1.9.1
    gem install sbire
    sbire install

OSX:

    brew install sox
    gem install sbire
    sbire install

Windows :

    Install ruby with [RubyInstall](http://rubyinstaller.org/)
    gem install sbire
    sbire install

## Usage

To run a command :

  - Open a terminal
  - Type `sbire start`
  - Say the command ("Firefox" for example)
  - Type `sbire stop`
  - The command will be executed

To write a text file :

  - Open a terminal
  - Type `sbire start`
  - Say the text ("This project rocks" for example)
  - Type `sbire save`
  - A file will be created in `~\.sbire\text`

If you want to see what is written in the file in real time, run `tail -f ~\.sbire\text`.

## Configuration

By default, the language is en-us. You can change it by adding a `~\.sbire\config.yml` file. For example. to set it to French, write:
```
lang: fr-FR`
```

## Bind phrase and commands

You can bind more complexe phrases with commands by adding a `~\.sbire\commands.yml` file and write for example:
```
    "chromium-browser": ["open chrome", "chrome"]
    "skype": "open skype"
```
## Add a shortcut

For some obscure reason, Ubuntu does not run ruby commands binded with a keyboard shortcut. You must install [xbindkeys](http://doc.ubuntu-fr.org/xbindkeys) to make it work.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
