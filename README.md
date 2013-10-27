# Sbire

In french, a "Sbire" is a henchman. It's the guy who do what you say. Sbire is program which is capable to listen what you said and execute the command associated.

## Installation

In Ubuntu :

    sudo apt-get install sox notify-osd ruby1.9.1
    gem install sbire
    mkdir ~\.sbire\

## Usage

To execute a command :

  - open a terminal
  - Type `sbire start`
  - say the command you want ("Firefox" for example)
  - type `sbire stop`
  - the command will be executed

To write a text file :

  - open a terminal
  - type `sbire start`
  - say what you want ("This project rocks" for example)
  - type `sbire save`
  - a file will be created in `~\.sbire\sbire.txt`

## Configuration

By default, the language is en-US. You can change it by adding a file `~\.sbire\config.yml` and put `lang: fr-FR` in it.

## Bind phrase and commands

You can bind more complexe phrases with commands by adding a file`~\.sbire\commands.yml` and put in it something like this :

    "chromium-browser": ["open chrome", "chrome"]
    "skype": "open skype"

## Make a shortcut

For an obscure reason, Ubuntu does not execute ruby commands binded with a keyboard shortcut. You must to install [xbindkeys](http://doc.ubuntu-fr.org/xbindkeys) to make it working.

## ToDo list

  - make it work with leap motion
  - make it cross-platform
  - enable streaming to write texts

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
