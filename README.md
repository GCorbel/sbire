# Sbire
[![Code Climate](https://codeclimate.com/github/GCorbel/sbire.png)](https://codeclimate.com/github/GCorbel/sbire)

"Sbire" is the French word for henchman. Sbire is program which is capable to listen what you said and execute the command associated.

## How it works

Sbire is using sox to record the voice and send files recorded to Google speech-api. Google speech-api analyze your voice and return corresponding words. The rest of the application is a simple ruby code. To emulate streaming, the record is splitted in many short files.

## Installation

Linux :

    sudo apt-get install sox notify-osd ruby1.9.1 xdotool
    gem install sbire
    sbire install

OSX:

    brew install sox
    sudo port install xdotool
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
  - The command will be executed

To write where your cursor is :

  - Open a terminal
  - Type `sbire pipe`
  - Say the text ("This project rocks" for example)
  - It will write the text where your cursor is

To write a text file :

  - Open a terminal
  - Type `sbire save`
  - Say the text ("This project rocks" for example)
  - A file will be created in `~\.sbire\text`

To stop sbire, type `sbire stop`.

If you want to see what is written in the file in real time, run `tail -f ~\.sbire\text`.

## Configuration

By default, the language is en-us. You can change it by changing the value of `lang` by your language. For example, to set it to French, write:
```
lang: fr-FR
```

## Bind phrase and commands

You can bind more complexe phrases with commands by adding a `~\.sbire\commands.yml` file and write for example:
```
"chromium-browser": ["open chrome", "chrome"]
"skype": "open skype"
```

## Pipe the text with a custom command

By default, when you use `sbire pipe`, it will use a command to emulate the keyboard. You can change it by editing the file `~\.sbire\config.yml` and change the value of `pipe_command` by anything you want.

## Add a shortcut

For some obscure reason, Ubuntu does not run ruby commands binded with a keyboard shortcut. You must install [xbindkeys](http://doc.ubuntu-fr.org/xbindkeys) to make it work.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
