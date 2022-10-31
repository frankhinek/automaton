#!/bin/bash
defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool yes
defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool yes