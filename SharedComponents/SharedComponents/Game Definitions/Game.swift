//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 11/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

public enum Game: String, CaseIterable, Identifiable {
    case minesweeper, wordcraft, numberCombinations, ticTacToe,
         othello,
         snake, adventure, matchedPairs, wordSearch

    public var id: Game { self }

    public var gameDefinition: GameDefinition {
        switch self {
        case .minesweeper:
            return minesweeperGame()
        case .wordcraft:
            return wordcraftGame()
        case .numberCombinations:
            return numberCombinationsGame()
        case .snake:
            return snakeGame()
        case .adventure:
            return pyramidOfDoom()
        case .ticTacToe:
            return ticTacToeGame()
        case .othello:
            return othelloGame()
        case .matchedPairs:
            return matchedPairsGame()
        case .wordSearch:
            return wordSearchGame()
        }
    }
}

extension Game {
    // swiftlint:disable line_length
    // MARK: - Minesweeper
    private func minesweeperGame() -> GameDefinition {
        GameDefinition(id: Game.minesweeper,
                       title: "Minesweeper",
                       tagLine: "Can you clear the mines?",
                       description: textBlock(
                        "Minesweeper is a classic game from the dim and distant past. The aim of the game is to identify all of the mines without clicking on one and setting it off.",
                        "Minesweeper rules are very simple. The board is divided into cells, with mines randomly distributed. To win, you need to open all the cells. The number on a cell shows the number of mines adjacent to it. Using this information, you can determine cells that are safe, and cells that contain mines. Cells suspected of being mines can be marked with a flag.",
                        "To win a game of Minesweeper, all non-mine cells must be opened without opening a mine. There is no score, but there is a timer recording the time taken to finish the game. Difficulty can be increased by adding mines or starting with a larger grid. You can do this via the settings panel. Beginner level is usually on an 8x8 or 9x9 board containing 10 mines, Intermediate is usually on a 16x16 board with 40 mines and expert is usually on a 22x22 board with 99 mines; however, you are free to customize board size and mine count."
                       ),
                       gamePlay: textBlock(
                        "When the game starts you will be presented with a grid. Under that grid are hidden a number of mines. It is your job to locate those mines and to clear every cell without a mine.",
                        "You select a cell by clicking on it. If the cell does not contain a mine, it will clear and surrounding cells will be updated to show how many cells border it. This is your only clue to the whereabouts of mined cells.",
                        "You can indicate that you believe a cell to contain a mine by long-pressing on it. When you do this a warning symbol will be placed on the cell. There is no guarantee that the cell actually contains a mine, so beware! If you change your mind, long-press to remove the marker.",
                        "The game ends when you either click on a mine or you clear all non-mine cells. If you clear all non-mine cells without opening a mine, you win!"
                       ),
                       credits: "Paul Hudson - Hacking With Swift+, with modifications by Steven Barnett",
                       link: "https://www.hackingwithswift.com/plus",
                       settingsIcon: "square.and.arrow.up"
        )
    }

    // MARK: - Word Craft
    private func wordcraftGame() -> GameDefinition {
        GameDefinition(id: Game.wordcraft,
                       title: "Word Craft",
                       tagLine: "Can you beat the word challenges?",
                       description: textBlock(
                        "WordCraft is a game where you have to use a limited number of letters to create a word. To make the game more challenging, you will be given a challenge to meet, such as a word with a specific number of letters or a word that starts with a specific letter.",
                        "There is no time limit to complete the challenge, but you must meet the challenge and you cannot use the same word more than once.",
                        "Letters you use to successfully create a word will be removed from the game board and replaced with a random set of replacement letters."
                       ),
                       gamePlay: textBlock(
                        "You can select specific letters by click on them in the grid. To submit your word for testing, you click the same letter twice. This will validate that the challenge has been met, that the word has not been used before and that it is in the games dictionary. If these are all met, the letters will be removed from the game and replacements generated.",
                        "If you click on a previously selected letter, it will become the last letter and any letters selected after it will be removed from your word. This gives you a quick way to remove multiple letters.",
                        "All words must be between 3 and 12 letters long.",
                        "As an alternative, you can use the  keyboard to select letters. If you do this, the game will randomly select a tile for you. Pressing return will submit your word for testing and backspace will remove letters from the word."),
                       credits: "Paul Hudson - Hacking With Swift+",
                       link: "https://www.hackingwithswift.com/plus",
                       settingsIcon: "textformat.abc"
        )
    }

    // MARK: - Snake
    private func snakeGame() -> GameDefinition {
        GameDefinition(id: Game.snake,
                       title: "Snake Game",
                       tagLine: "Feed the snake, but beware the borders",
                       description: textBlock(
                        "This is a classic game from the early days of computing. The premise is very simple but game play is surprisingly difficult the longer you play. ",
                        "Your job is to guide the snake towards it's food. The snake will grow longer as it eats food. If it touches the borders or itself, it will die. As the game progresses and the snake grows longer and longer, you will need to work out routes to the food that will not cause the snake to die.",
                        "The game is very addictive and can be played for hours. It is a great way to spend a few minutes."
                       ),
                       gamePlay: textBlock(
                        "The snake is controlled using the arrow keys on the keyboard. You can also pause play by pressing the space bar. When you are ready to resume, press space again."
                       ),
                       credits: "Steve Barnett",
                       link: "http://www.sabarnett.co.uk",
                       settingsIcon: "scribble.variable"
        )
    }

    // MARK: - Pyramid of Doom
    private func pyramidOfDoom() -> GameDefinition {
        GameDefinition(id: Game.adventure,
                       title: "Pyramid of Doom",
                       tagLine: "Can you survive the pyramid of doom?",
                       description: textBlock(
                        "This is an Adventure that will transport you to a dangerous land of crumbling ruins and trackless desert wastes into the PYRAMID OF DOOM! Jewels, gold -- it's all here for the plundering -- IF you can find the way.",
                        "(Difficulty Level: Moderate)",
                        "Your mission is simple, find al the treasures before the pyramid kills you.",
                        "You are going to navigate from location to location using text commands like 'north', 'south', 'east', 'west', 'take item', 'drop item', 'read', 'inventory' and 'help'. There are many more commands, just try them out!"
                       ),
                       gamePlay: textBlock(
                        "Draw a map as you go, there are a lot more places than you think and without a map you will end up going round in circles or missing areas which you haven't tried. It doesn't need to be perfect as long as you have some record of where you have been and what you've found (as well as where you found it). Examine things you find and try to remember that most problems have solutions that require no more than some careful thought and a little common sense. If you get stuck try typing HELP -- you may or may not get assistance but you won't know until you ask. And be careful about assuming things, it can be fatal.",
                        "To speed things up you may use the following abbreviations N, S, E, W, U, D, for Go North, South, East, West, Up or Down. I is short for Inventory and will list what you're carrying.",
                        "Some (but not all) of the words available that you may find useful are: --",
                        "Get, Take, Drop, Go, Climb, Jump, Enter, Examine, Go, Leave, Move, Quit, Say, Wear, Read, Save, Light, Pull, Push and Look ... There are others!!!",
                        "Instructions are entered by you in the form of two word commands with the first word being a verb. If the computer doesn't understand, it will tell you so and you must try rewording what you wish to do (e.g. instead of GO FLYING try FLY). You will find that objects which can be picked up usually require only the last part of their name as in the Blue Ox where typing GET OX is all that is needed.",
                        "Good luck, happy adventuring and try not to die too often."
                       ),
                       credits: "Steve Barnett",
                       link: "http://www.sabarnett.co.uk")
    }

    // MARK: - Number Combinations
    private func numberCombinationsGame() -> GameDefinition {
        GameDefinition(id: Game.numberCombinations,
                       title: "Number Combinations",
                       tagLine: "Can you make the formula work?",
                       description: textBlock(
                        "This is a deceptively simple game where you are provided with a set of numbers and the result you are required to achieve. The hard part is that you have to work out the formula!",
                        "You must use the four digits provided, in any order, to achieve the target number. You are allowed to use any combination of + - * or / in your calculation and may use brackets as you see fit. To keep calculations simple (ok, that's a matter of opinion) division is integer division, so any remainder from a divide will be lost. 3/2 will result in 1.",
                        "There is no one right formula. Various combinations of numbers and operators will work."
                       ),
                       gamePlay: textBlock(
                        "Using all four digits, create a formula that will result in the target number. You may use addition, subtraction, multiplication and division and can use brackets as you see fit.",
                        "Division is integer division, so any remainder will be ignored. For example, dividing 3 by 2 will result in 1, not 1.5. This is intended to make the formula easier to create.",
                        "As you type the formula, any used numbers will be highlighted and a running total will be created when the formula is valid."
                       ),
                       credits: "Steven Barnett",
                       link: "http://www.sabarnett.co.uk",
                       settingsIcon: "squareshape.split.2x2.dotted"
        )
    }

    // MARK: - Tic Tac Toe
    private func ticTacToeGame() -> GameDefinition {
        GameDefinition(id: Game.ticTacToe,
                       title: "Tic Tac Toe",
                       tagLine: "Can you beat the computer?",
                       description: textBlock(
                        "Better known to some of us oldies as 'Noughts and Crosses', Tic-Tac-Toe is a classic game that has been played for centuries. It is a simple game that can be played by two people or, in our case, one player against a a fiendish computer.",
                        "The game is played on a 3x3 grid, and each player takes turns placing their mark in a square. The player who gets three in a row horizontally, vertically, or diagonally wins the game.",
                        "The game is simple, but quite hard to win against the AI built into the computer. Can you beat the computer?"
                       ),
                       gamePlay: textBlock(
                        "The player and computer take turns picking a square. Click on a square and it will be turned over and the computer will analyse the board and pick a move of it's own.",
                        "You are trying to get a line of three squares in a row (horizontally or vertically) or diagonally across the board. The computer is doing the same thing.",
                        "You can stop a player winning by selecting a square that stops the other player from getting a row of three. It's not as easy as it sounds!"
                       ),
                       credits: "Steven Barnett",
                       link: "http://www.sabarnett.co.uk"
        )
    }

    // MARK: - Othello
    private func othelloGame() -> GameDefinition {
        GameDefinition(id: Game.othello,
                       title: "Othello",
                       tagLine: "Tile based logic game",
                       description: textBlock(
                        "Othello is a strategy board game for two players (you and the computer), played on an 8 by 8 board. The game traditionally begins with four discs placed in the middle of the board. The computer will randomly select who goes first. The player always plays black and the computer white. There is no advantage to the colour of the pieces.",
                        "You must place a disc on the board, in such a way that there is at least one straight (horizontal, vertical, or diagonal) occupied line between the new disc and another of your discs, with one or more contiguous computer pieces between them. ",
                        "After placing the disc, the opposition discs flip lying on a straight line between the new disc and any existing discs. All flipped discs are now yours. Now the computer plays. This computer operates under the same rules, with the roles reversed: it lays down a disc, causing your discs to flip.",
                        "Where there are no moves available, you or the computer skips their move and control reverts to the other player. The game ends when the board is full or neither player can move. At this time, the winner is determined by who has the most face up discs."
                       ),
                       gamePlay: textBlock(
                        "The first four moves are already on the board in one of the four squares in the middle of the board and no pieces are captured or reversed.",
                        "Each piece played must be laid adjacent to an opponent's piece so that the opponent's piece or a row of opponent's pieces is flanked by the new piece and another piece of the player's colour. All of the opponent's pieces between these two pieces are 'captured' and turned over to match the player's colour.",
                        "It can happen that a piece is played so that pieces or rows of pieces in more than one direction are trapped between the new piece played and other pieces of the same colour. In this case, all the pieces in all viable directions are turned over.",
                        "The game is over when neither player has a legal move (i.e. a move that captures at least one opposing piece) or when the board is full. At this time, the winner is determined by who has the most face up discs."
                       ),
                       credits: "Steven Barnett",
                       link: "http://www.sabarnett.co.uk"
        )
    }

    // MARK: - Matched Pairs
    private func matchedPairsGame() -> GameDefinition {
        GameDefinition(id: Game.matchedPairs,
                       title: "Matched Pairs",
                       tagLine: "How good is your memory",
                       description: textBlock(
                        "This is a game of memory. The game will randomly select cards from a deck and present them to you face down. There are two of each card on the game board and your job is to match them up.",
                        "You click on a card to turn it over. If you click on two cards that match, they are removed from the game board. If not, they will turn back down and you will need to pick another two cards.",
                        "The aim is to find all the matched pairs in as short a times as possible. Yuo can vary the difficulty of the game through the settings window."
                       ),
                       gamePlay: textBlock(
                        "Click on a card to turn it over. Then click on a second card to see if it matches the first.",
                        "If the cards match, they are taken out of the game. If they do not match, when you click on the next card, the two you previously selected will be turned face down.",
                        "The game is complete when you have matched all card pairs."
                       ),
                       credits: "Steven Barnett",
                       link: "http://www.sabarnett.co.uk",
                       settingsIcon: "square.and.line.vertical.and.square"
        )
    }

    // MARK: - Word Search
    private func wordSearchGame() -> GameDefinition {
        GameDefinition(id: Game.wordSearch,
                       title: "Word Search",
                       tagLine: "Can you find all the words?",
                       description: textBlock(
                        "This is a game of observation. You will be presented with a grid of seemingly random letters. Hidden in the grid will be a number of words for you to find.",
                        "Your task is to find all of the words in the grid. You do this by seecting the first and last letter of the word, which will cause it to be highlighted in the grid. ",
                        "Words can appear vertically, horizontally or diagonally and, to make things more fun, may also be revresed. as each word is found, it will be removed from the list. If you are stuck and the hints option is enabled, you can press a character on the keyboard to briefly highlight all occurences of a single letter. This does, however, come with a 10 second penalty."
                       ),
                       gamePlay: textBlock(
                        "Choose the word you want to find and click on the first and last letter of that word in the grid.",
                        "If you have selected a correct word, it will be highlighted. If you select a letter that you do not want, click it a second time to de-select it. If you are stuck and the hints option is enabled, you can press a character on the keyboard to briefly highlight all occurences of a single letter. This does, however, come with a 10 second penalty.",
                        "The game is complete when you have found all the words."
                       ),
                       credits: "Steven Barnett",
                       link: "http://www.sabarnett.co.uk",
                       settingsIcon: "wonsign.square.fill"
        )
    }

    // swiftlint:enable line_length

    /// textBlock - takes a variadic parameter list of strings and returns a
    /// single string with each parameter separated by two newline characters.
    ///
    /// Used to make it easier and more readable to create the description text
    /// for a game.
    private func textBlock(_ text: String...) -> String {
        text.joined(separator: "\n\n")
    }
}
