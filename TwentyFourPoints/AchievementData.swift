//
//  AchievementData.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/26.
//

import Foundation

struct Achievement {
    var name: String
    var lvlReq: Int
    var secret: Bool
    var description: String
}

var achievement: [Achievement] = [
    Achievement(name: "Jonathan",lvlReq: 10, secret: false,description: "Although Jonathan is intellectually capable, his love for sleeping leaves him at the bottom of the 24 Points chain."),
    Achievement(name: "Harrison", lvlReq: 20, secret: false, description: "More interested in Chemistry than Math and music games more than puzzles, Harrison's a decent 24 Points player purely by his mental capabilities."),
    Achievement(name: "Alex",lvlReq: 50, secret: false,description: "Alex is keener to write the fastest 24 Points robot than to actually play the game. However, his potential robot does give him a possible opportunity to dethrone the math titans."),
    Achievement(name: "Michel",lvlReq: 100,secret: false,description: "Michel, like Alex, is more interested in writing code than actually playing the game, with his 100 levels purely from playtesting his app."),
    Achievement(name: "Ethan",lvlReq: 200,secret:false,description: "When Ethan isn't busy playing or sleeping with his stuffed avocado, he can be seen busily doing physics or programming. His talent in everything STEM shows in his undeniable performance in 24 Points."),
    Achievement(name: "Ella",lvlReq: 300,secret:false,description: "When Ella isn't being Mrs. Styles, she's seen busily studying Biology or sneaking glances at Zayn. Ella's intense focus on everything makes her a fantastic 24 Points player."),
    Achievement(name: "Alyx",lvlReq: 400,secret:false,description: "When Alyx isn't playing League of Legends or Subnautica, he's seen busily working on math olympiads. His math skills make him an impressive 24 Points player."),
    Achievement(name: "Mimi",lvlReq: 500,secret:false,description: "When Mimi's not busy writing poetry or managing teams, she's seen at the gym checking out the chads. Mimi's dedication and intellect make her a formidable 24 Points player."),
    Achievement(name: "Mike",lvlReq: 750,secret:false,description: "When Mike isn't busy designing or latching speakers playing Justin Bieber onto friends, Mike can be seen playing 24 Points."),
    Achievement(name: "Sarah",lvlReq: 1000,secret:false,description: "Sarah's focus on machine learning has given her plenty of time to play 24 Points (and stare at her seven husbands) as she waits for her next state-of-the-art model to finish training."),
    Achievement(name: "Max",lvlReq: 2000,secret:false,description: "Max's undisputed strength in everything mathematics has transferred over to 24 Points, making him an astonishingly speedy player despite his lack of time playing the game."),
    Achievement(name: "Sophie",lvlReq: 3000,secret:false,description: "Sophie's incredible intellect and playful persona make her one of the best 24 Points players, only surpassed by one that knows the game and plays it by heart while giving it his full commitment."),
    Achievement(name: "Rick Astley",lvlReq: 10000,secret:true,description: "Rick Astley is never gonna give you up or let you down. His full commitment marks him as the gold standard for the best 24 Points players.")
]
