# Homebrew Installation Script for CASSY Lab 2 (using Wine)
This is a Homebrew Formula to install LD DIDACTIC CASSY Lab 2, which is a Windows .NET Application and requires Wine on Mac OS.
# Requirements
Requires MacOS X >= 10.11 (El Capitan), Homebrew and XQuartz.
# Prerequisites
First you need Homebrew. Follow the instructions on https://brew.sh, if you don't alread have Homebrew installed. You also need
XQuartz, which can then be installed using Homebrew:
```
brew cask install xquartz
```
# Installation
Add the CASSY Lab tap to homebrew:
```
brew tap lddidactic/cassylab2
```
and run the CASSY Lab 2 installation:
```
brew install cassylab2
```
As Homebrew formulas do not write outside their own directories, no Application link is created. This can be done either by
```
ln -s <installpath>/cassylab2.app ~/Applications/
```
for the current user, or 
```
ln -s <installpath>/cassylab2.app /Applications/
```
for all users of the machine. The install path is shown at the end of a successful installation.
