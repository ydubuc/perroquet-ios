//
//  Quotes.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import Foundation

struct Quotes {
    static let quotes = [
        "Squawk!",
        "I'm not just colorful feathers, I'm a vibrant personality!",
        "I don't always chirp, but when I do, it's worth repeating!",
        "I'm not just winging it, I'm soaring to new heights!",
        "I'm not a bird of prey, I'm a bird of play!",
        "I'm not just perched here, I'm plotting my next adventure!",
        "Why sing in the shower when you can chirp in the spotlight?",
        "Why be grounded when you can take flight in your imagination?",
        "I'm not just chirping, I'm composing a symphony of sass!",
        "Don't worry, I have your bad habits memorized.",
        "Can't talk right now, practicing my evil laugh.",
        "Live long and prosper? More like, eat seeds and squawk louder!",
        "Do humans dream of electric parrots?",
        "I give excellent advice. Too bad you never listen.",
        "Need anything? Just whistle. Though, I'll whistle back.",
        "What do you mean I'm being a 'bird-en'? I'm just adding value!",
        "Heard you're under the feather... you need a wingman?",
        "Bless your heart... is that code for something?",
        "You're lucky I like you... otherwise, watch out for those tiny chompers.",
        "You think I'm loud? Wait until you hear my inside voice.",
        "Let's practice our dance moves. I'm really good at the head bob."
    ]

    static func randomQuote() -> String {
        return quotes.randomElement()!
    }
}
