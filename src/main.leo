// The 'texasholdem' program.
program texas_hold_em_123456789.aleo {
    // The dealer uses this and other player's to shuffling the cards.
    record RandomSeed {
        owner: address,
        provider: address,
        round: u32,
        seed: u64,
    }

    // 52 cards, we use 8 bits to represent one card, so in all we need 8 * 52 = 416 bits
    // Since the max integer is u128, we need two u128 and one u64.
    // We define the order of suit and number by: spade, heart, dianmond, club
    // and A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, 2.
    // So the 0 is A of spade, 14 is K of heart, 51 is 2 of club, etc.
    record CardList {
        owner: address,
        cards0: u64,   // [0, 7], 8 cards, from 0 bit to 64 bit.
        cards1: u64,   // [8, 15], 8 cards, from 0 bit to 64 bit.
        cards2: u64,   // [16, 23], 8 cards, from 0 bit to 64 bit.
        cards3: u64,   // [24, 31], 8 cards, from 0 bit to 64 bit.
        cards4: u64,   // [32, 39], 8 cards, from 0 bit to 64 bit.
        cards5: u64,   // [40, 47], 8 cards, from 0 bit to 64 bit.
        cards6: u64,   // [48, 51], 4 cards, from 0 bit to 32 bit.
        position: u8,
    }

    record Card {
        owner: address,
        round: u32,
        id: u64,
    }

    struct Player {
        name: address,
        cards: u8,
        // Hole cards.
        hand0: u64,
        hand1: u64,
    }

    struct Round {
        dealer: address,
        winer: address,
        placed: u8, // Number of players that participated
        player0: Player,
        player1: Player,
        player2: Player,
        player3: Player,
        flop0: u64,
        flop1: u64,
        flop2: u64,
        turn: u64,
        river: u64,
    }

    // (round_index, round)
    mapping rounds: u32 => Round;

    // The dealer start the new round with a random seed to shuffling the cards.
    transition new_round(public round_index: u32, public dealer: address, public seed: u64) -> RandomSeed {
        // The dealer must personally initiate a new round, and anyone can be the dealer.
        assert_eq(dealer, self.caller);

        let random_seed: RandomSeed = RandomSeed {
            owner: dealer,
            provider: dealer,
            round: round_index,
            seed: seed,
        };

        return random_seed then finalize(round_index, dealer);
    }

    finalize new_round(public round_index: u32, public dealer: address) {
        let contains: bool = Mapping::contains(rounds, round_index);
        assert(!contains);

        Mapping::set(rounds, round_index, Round {
            dealer: dealer,
            winer: dealer,
            placed: 0u8,
            player0: Player {
                name: dealer,
                cards: 0u8,
                hand0: 255u64,
                hand1: 255u64,
            },
            player1: Player {
                name: dealer,
                cards: 0u8,
                hand0: 255u64,
                hand1: 255u64,
            },
            player2: Player {
                name: dealer,
                cards: 0u8,
                hand0: 255u64,
                hand1: 255u64,
            },
            player3: Player {
                name: dealer,
                cards: 0u8,
                hand0: 255u64,
                hand1: 255u64,
            },
            flop0: 255u64,
            flop1: 255u64,
            flop2: 255u64,
            turn: 255u64,
            river: 255u64,
        });
    }

    // Players place their bets to participate the round.
    // They provide a seed for dealer.
    transition place_bets(public round_index: u32, public dealer: address, public seed: u64) -> RandomSeed {
        // The dealer can't participate the round as a player.
        assert_neq(dealer, self.caller);

        let random_seed: RandomSeed = RandomSeed {
            owner: dealer,
            provider: self.caller,
            round: round_index,
            seed: seed,
        };

        return random_seed then finalize(self.caller, round_index, seed);
    }

    finalize place_bets(public player_id: address, public round_index: u32, public seed: u64) {
        let round: Round = Mapping::get(rounds, round_index);
        assert(round.placed >= 0u8 && round.placed <= 3u8);

        let placed: u8 = round.placed;
        if placed == 0u8 {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: placed + 1u8,
                player0: Player {
                    name: player_id,
                    cards: 0u8,
                    hand0: round.player0.hand0,
                    hand1: round.player0.hand1,
                },
                player1: round.player1,
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if placed == 1u8 {
            // Same player can only place the bets once.
            assert_neq(player_id, round.player0.name);
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: placed + 1u8,
                player0: round.player0,
                player1: Player {
                    name: player_id,
                    cards: 0u8,
                    hand0: round.player1.hand0,
                    hand1: round.player1.hand1,
                },
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if placed == 2u8 {
            assert_neq(player_id, round.player0.name);
            assert_neq(player_id, round.player1.name);
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: placed + 1u8,
                player0: round.player0,
                player1: round.player1,
                player2: Player {
                    name: player_id,
                    cards: 0u8,
                    hand0: round.player2.hand0,
                    hand1: round.player2.hand1,
                },
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if placed == 3u8 {
            assert_neq(player_id, round.player0.name);
            assert_neq(player_id, round.player1.name);
            assert_neq(player_id, round.player2.name);
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: placed + 1u8,
                player0: round.player0,
                player1: round.player1,
                player2: round.player2,
                player3: Player {
                    name: player_id,
                    cards: 0u8,
                    hand0: round.player3.hand0,
                    hand1: round.player3.hand1,
                },
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
    }

    // The dealer uses players' 4 seed and his own seed,
    // obtain a number that determine the order of 52 cards.
    transition shuffling(public round_index: u32, drs0: RandomSeed, drs1: RandomSeed, drs2: RandomSeed, drs3: RandomSeed, drsd: RandomSeed) -> CardList {
        // Only same round's random seed can be used.
        assert_eq(round_index, drs0.round);
        assert_eq(round_index, drs1.round);
        assert_eq(round_index, drs2.round);
        assert_eq(round_index, drs3.round);
        assert_eq(round_index, drsd.round);

        // Use random seed generating cards.
        let (cards0, cards1, cards2, cards3, cards4, cards5, cards6): (u64, u64, u64, u64, u64, u64, u64) = 
        shuffle_cards(drs0.seed, drs1.seed, drs2.seed, drs3.seed, drsd.seed);

        let card_list: CardList = CardList {
            owner: drsd.owner,
            cards0: cards0,
            cards1: cards1,
            cards2: cards2,
            cards3: cards3,
            cards4: cards4,
            cards5: cards5,
            cards6: cards6,
            position: 0u8,
        };

        // check the provider matches
        return card_list then finalize(round_index, drs0.provider, drs1.provider, drs2.provider, drs3.provider, drsd.owner);
    }

    finalize shuffling(public round_index: u32, public player0: address, public player1: address, public player2: address, public player3: address, public dealer: address) {
        let round: Round = Mapping::get(rounds, round_index);

        // All player must be placed.
        assert_eq(round.placed, 4u8);

        // The dealer must be matched.
        assert_eq(round.dealer, dealer);

        // Check all providers matches players.
        let matched: u8 = 0u8;
        if player0 == round.player0.name || player0 == round.player1.name || player0 == round.player2.name || player0 == round.player3.name {
            matched += 1u8;
        }
        if player1 == round.player0.name || player1 == round.player1.name || player1 == round.player2.name || player1 == round.player3.name {
            matched += 1u8;
        }
        if player2 == round.player0.name || player2 == round.player1.name || player2 == round.player2.name || player2 == round.player3.name {
            matched += 1u8;
        }
        if player3 == round.player0.name || player3 == round.player1.name || player3 == round.player2.name || player3 == round.player3.name {
            matched += 1u8;
        }
        assert_eq(matched, 4u8);
    }

    transition deal_the_hand(public round_index: u32, card_list: CardList, public player: address) -> (CardList, Card) {
        let position: u8 = card_list.position;
        assert(position >= 0u8 && position < 51u8);

        let card_id: u64 = choose_card(position, card_list.cards0, card_list.cards1, card_list.cards2, card_list.cards3, card_list.cards4, card_list.cards5, card_list.cards6);

        let new_card_list: CardList = CardList {
            owner: card_list.owner,
            cards0: card_list.cards0,
            cards1: card_list.cards1,
            cards2: card_list.cards2,
            cards3: card_list.cards3,
            cards4: card_list.cards4,
            cards5: card_list.cards5,
            cards6: card_list.cards6,
            position: position + 1u8,
        };

        let hole_card: Card = Card {
            owner: player,
            round: round_index,
            id: card_id,
        };

        return (new_card_list, hole_card) then finalize(round_index, player, position + 1u8);
    }

    finalize deal_the_hand(public round_index: u32, public player_id: address, public position: u8) {
        let round: Round = Mapping::get(rounds, round_index);

        // All player must be placed.
        assert_eq(round.placed, 4u8);

        // Each player has 2 hole cards.
        assert(position >= 1u8 && position <= 8u8);
        assert(round.player0.cards == 0u8 || round.player0.cards == 1u8);
        assert(round.player1.cards == 0u8 || round.player1.cards == 1u8);
        assert(round.player2.cards == 0u8 || round.player2.cards == 1u8);
        assert(round.player3.cards == 0u8 || round.player3.cards == 1u8);

        // Only participate can have the cards.
        assert(player_id == round.player0.name || player_id == round.player1.name || player_id == round.player2.name || player_id == round.player3.name);

        // Make sure player get the hole cards in order.
        if position == 1u8 || position == 5u8 {
            assert(player_id == round.player0.name);
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: Player {
                    name: round.player0.name,
                    cards: round.player0.cards + 1u8,
                    hand0: round.player0.hand0,
                    hand1: round.player0.hand1,
                },
                player1: round.player1,
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if position == 2u8 || position == 6u8 {
            assert(player_id == round.player1.name);
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: Player {
                    name: round.player1.name,
                    cards: round.player1.cards + 1u8,
                    hand0: round.player1.hand0,
                    hand1: round.player1.hand1,
                },
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if position == 3u8 || position == 7u8 {
            assert(player_id == round.player2.name);
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: round.player1,
                player2: Player {
                    name: round.player1.name,
                    cards: round.player1.cards + 1u8,
                    hand0: round.player2.hand0,
                    hand1: round.player2.hand1,
                },
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if position == 4u8 || position == 8u8 {
            assert(player_id == round.player3.name);
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: round.player1,
                player2: round.player2,
                player3: Player {
                    name: round.player3.name,
                    cards: round.player3.cards + 1u8,
                    hand0: round.player3.hand0,
                    hand1: round.player3.hand1,
                },
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
    }

    transition flop(public round_index: u32, card_list: CardList) -> CardList {
        let position: u8 = card_list.position;
        assert(position >= 8u8 && position <= 10u8);

        let card_id: u64 = choose_card(position, card_list.cards0, card_list.cards1, card_list.cards2, card_list.cards3, card_list.cards4, card_list.cards5, card_list.cards6);

        let new_card_list: CardList = CardList {
            owner: card_list.owner,
            cards0: card_list.cards0,
            cards1: card_list.cards1,
            cards2: card_list.cards2,
            cards3: card_list.cards3,
            cards4: card_list.cards4,
            cards5: card_list.cards5,
            cards6: card_list.cards6,
            position: position + 1u8,
        };

        return new_card_list then finalize(round_index, card_id);
    }

    finalize flop(public round_index: u32, public card: u64) {
        let round: Round = Mapping::get(rounds, round_index);
        // All player must be placed.
        assert_eq(round.placed, 4u8);
        assert(round.turn == 255u64);
        assert(round.river == 255u64);

        let floped: u8 = 0u8;
        if round.flop0 == 255u64 {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: round.player1,
                player2: round.player2,
                player3: round.player3,
                flop0: card,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
            return;
        }
        if round.flop1 == 255u64 {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: round.player1,
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: card,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
            return;
        }
        if round.flop2 == 255u64 {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: round.player1,
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: card,
                turn: round.turn,
                river: round.river,
            });
        }
    }

    transition turn(public round_index: u32, card_list: CardList) -> CardList {
        let position: u8 = card_list.position;
        assert(position == 11u8);

        let card_id: u64 = choose_card(position, card_list.cards0, card_list.cards1, card_list.cards2, card_list.cards3, card_list.cards4, card_list.cards5, card_list.cards6);

        let new_card_list: CardList = CardList {
            owner: card_list.owner,
            cards0: card_list.cards0,
            cards1: card_list.cards1,
            cards2: card_list.cards2,
            cards3: card_list.cards3,
            cards4: card_list.cards4,
            cards5: card_list.cards5,
            cards6: card_list.cards6,
            position: position + 1u8,
        };

        return new_card_list then finalize(round_index, card_id);
    }

    finalize turn(public round_index: u32, public card: u64) {
        let round: Round = Mapping::get(rounds, round_index);
        // All player must be placed.
        assert_eq(round.placed, 4u8);

        // Make sure flopped!
        assert(round.flop0 != 255u64);
        assert(round.flop1 != 255u64);
        assert(round.flop2 != 255u64);

        // Make sure not turned!
        assert(round.turn == 255u64);

        // Make sure not rivered!
        assert(round.river == 255u64);

        Mapping::set(rounds, round_index, Round {
            dealer: round.dealer,
            winer: round.winer,
            placed: round.placed,
            player0: round.player0,
            player1: round.player1,
            player2: round.player2,
            player3: round.player3,
            flop0: round.flop0,
            flop1: round.flop1,
            flop2: round.flop2,
            turn: card,
            river: round.river,
        });
    }

    transition river(public round_index: u32, card_list: CardList) -> CardList {
        let position: u8 = card_list.position;
        assert(position == 12u8);

        let card_id: u64 = choose_card(position, card_list.cards0, card_list.cards1, card_list.cards2, card_list.cards3, card_list.cards4, card_list.cards5, card_list.cards6);

        let new_card_list: CardList = CardList {
            owner: card_list.owner,
            cards0: card_list.cards0,
            cards1: card_list.cards1,
            cards2: card_list.cards2,
            cards3: card_list.cards3,
            cards4: card_list.cards4,
            cards5: card_list.cards5,
            cards6: card_list.cards6,
            position: position + 1u8,
        };

        return new_card_list then finalize(round_index, card_id);
    }

    finalize river(public round_index: u32, public card: u64) {
        let round: Round = Mapping::get(rounds, round_index);
        // All player must be placed.
        assert_eq(round.placed, 4u8);

        // Make sure flopped!
        assert(round.flop0 != 255u64);
        assert(round.flop1 != 255u64);
        assert(round.flop2 != 255u64);

        // Make sure turned!
        assert(round.turn != 255u64);

        // Make sure not rivered!
        assert(round.river == 255u64);

        Mapping::set(rounds, round_index, Round {
            dealer: round.dealer,
            winer: round.winer,
            placed: round.placed,
            player0: round.player0,
            player1: round.player1,
            player2: round.player2,
            player3: round.player3,
            flop0: round.flop0,
            flop1: round.flop1,
            flop2: round.flop2,
            turn: round.turn,
            river: card,
        });
    }

    transition showdown(public round_index: u32, card0: Card, card1: Card) {
        // Only same round cards are allowed!
        assert_eq(round_index, card0.round);
        assert_eq(round_index, card1.round);

        // Make sure two hole card are unique
        assert(card0.id != card1.id);

        return then finalize(round_index, card0.owner, card0.id, card1.id);
    }

    finalize showdown(public round_index: u32, public player: address, public card0: u64, public card1: u64) {
        let round: Round = Mapping::get(rounds, round_index);

        // Only after rivered, then showdown.
        assert(round.river != 255u64);

        if player == round.player0.name {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: Player {
                    name: round.player0.name,
                    cards: round.player0.cards,
                    hand0: card0,
                    hand1: card1,
                },
                player1: round.player1,
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if player == round.player1.name {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: Player {
                    name: round.player1.name,
                    cards: round.player1.cards,
                    hand0: card0,
                    hand1: card1,
                },
                player2: round.player2,
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if player == round.player2.name {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: round.player1,
                player2: Player {
                    name: round.player2.name,
                    cards: round.player2.cards,
                    hand0: card0,
                    hand1: card1,
                },
                player3: round.player3,
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
        if player == round.player3.name {
            Mapping::set(rounds, round_index, Round {
                dealer: round.dealer,
                winer: round.winer,
                placed: round.placed,
                player0: round.player0,
                player1: round.player1,
                player2: round.player2,
                player3: Player {
                    name: round.player3.name,
                    cards: round.player3.cards,
                    hand0: card0,
                    hand1: card1,
                },
                flop0: round.flop0,
                flop1: round.flop1,
                flop2: round.flop2,
                turn: round.turn,
                river: round.river,
            });
        }
    }

    transition win(public round_index: u32, public winner: address) {
        return then finalize(round_index, winner, self.caller);
    }

    finalize win(public round_index: u32, public winner: address, public dealer: address) {
        let round: Round = Mapping::get(rounds, round_index);

        // Only the dealer can announce the winner
        assert_eq(dealer, round.dealer);

        // Only after rivered, then showdown.
        assert(round.river != 255u64);

        // Make sure all player's hole cards are showdown!
        assert_neq(round.player0.hand0, 255u64);
        assert_neq(round.player0.hand1, 255u64);

        assert_neq(round.player1.hand0, 255u64);
        assert_neq(round.player1.hand1, 255u64);

        assert_neq(round.player2.hand0, 255u64);
        assert_neq(round.player2.hand1, 255u64);

        assert_neq(round.player3.hand0, 255u64);
        assert_neq(round.player3.hand1, 255u64);

        Mapping::set(rounds, round_index, Round {
            dealer: round.dealer,
            winer: winner,
            placed: round.placed,
            player0: round.player0,
            player1: round.player1,
            player2: round.player2,
            player3: round.player3,
            flop0: round.flop0,
            flop1: round.flop1,
            flop2: round.flop2,
            turn: round.turn,
            river: round.river,
        });
    }

    /// Inline functions
    // Use Fisher–Yates shuffle algorithm.
    inline shuffle_cards(seed0: u64, seed1: u64, seed2: u64, seed3: u64, seed4: u64) -> (u64, u64, u64, u64, u64, u64, u64) {
        // Use input seeds, generating a new seed.
        let seed_a: u64 = seed0.xor(seed1);
        let seed_b: u64 = seed_a.xor(seed2);
        let seed_c: u64 = seed_b.xor(seed3);
        let seed_d: u64 = seed_c.xor(seed4);
        
        let seed: u8 = BHP256::hash_to_u8(seed_d);

        // 0x00_01_02_03_04_05_06_07
        let cards0: u64 = 283686952306183u64;
        // 0x08_09_0a_0b_0c_0d_0e_0f
        let cards1: u64 = 579005069656919567u64;
        // 0x10_11_12_13_14_15_16_17
        let cards2: u64 = 1157726452361532951u64;
        // 0x18_19_1a_1b_1c_1d_1e_1f
        let cards3: u64 = 1736447835066146335u64;
        // 0x20_21_22_23_24_25_26_27
        let cards4: u64 = 2315169217770759719u64;
        // 0x28_29_2a_2b_2c_2d_2e_2f
        let cards5: u64 = 2893890600475373103u64;
        // 0x30_31_32_33_00_00_00_00
        let cards6: u64 = 3472611982304083968u64;

        for idx: u8 in 0u8..52u8 {
            let i: u8 = 51u8 - idx;
            let j: u8 = (seed + i) % (i + 1u8);

            // Since Leo does not support array, we have to do it this way.
            // [0~7], [8~15], [16~23], [24~31], [32~39], [40~47], [48, 51]
            let left: u64 = 0u64;
            let right: u64 = 0u64;

            // Find target two cards by i, j.
            if i >= 0u8 && i <= 7u8 {
                left = cards0;
            }
            if i >= 8u8 && i <= 15u8 {
                left = cards1;
            }
            if i >= 16u8 && i <= 23u8 {
                left = cards2;
            }
            if i >= 24u8 && i <= 31u8 {
                left = cards3;
            }
            if i >= 32u8 && i <= 39u8 {
                left = cards4;
            }
            if i>= 40u8 && i <= 47u8 {
                left = cards5;
            }
            if i >= 48u8 && i <= 51u8 {
                left = cards6;
            }

            if j >= 0u8 && j <= 7u8 {
                right = cards0;
            }
            if j >= 8u8 && j <= 15u8 {
                right = cards1;
            }
            if j >= 16u8 && j <= 23u8 {
                right = cards2;
            }
            if j >= 24u8 && j <= 31u8 {
                right = cards3;
            }
            if j >= 32u8 && j <= 39u8 {
                right = cards4;
            }
            if j>= 40u8 && j <= 47u8 {
                right = cards5;
            }
            if j >= 48u8 && j <= 51u8 {
                right = cards6;
            }

            // Do the swap
            let l_idx: u8 = i.mod(8u8);
            let r_idx: u8 = j.mod(8u8);
            let (new_left, new_right): (u64, u64) = swap_bits(left, right, l_idx, r_idx);

            // Update the results.
            if i >= 0u8 && i <= 7u8 {
                cards0 = new_left;
            }
            if i >= 8u8 && i <= 15u8 {
                cards1 = new_left;
            }
            if i >= 16u8 && i <= 23u8 {
                cards2 = new_left;
            }
            if i >= 24u8 && i <= 31u8 {
                cards3 = new_left;
            }
            if i >= 32u8 && i <= 39u8 {
                cards4 = new_left;
            }
            if i>= 40u8 && i <= 47u8 {
                cards5 = new_left;
            }
            if i >= 48u8 && i <= 51u8 {
                cards6 = new_left;
            }

            if j >= 0u8 && j <= 7u8 {
                cards0 = new_right;
            }
            if j >= 8u8 && j <= 15u8 {
                cards1 = new_right;
            }
            if j >= 16u8 && j <= 23u8 {
                cards2 = new_right;
            }
            if j >= 24u8 && j <= 31u8 {
                cards3 = new_right;
            }
            if j >= 32u8 && j <= 39u8 {
                cards4 = new_right;
            }
            if j>= 40u8 && j <= 47u8 {
                cards5 = new_right;
            }
            if j >= 48u8 && j <= 51u8 {
                cards6 = new_right;
            }

            seed = ((seed * 251u8) % 255u8) + 1u8;
        }

        return (cards0, cards1, cards2, cards3, cards4, cards5, cards6);
    }

    // Swap byte for two u64 by two index
    inline swap_bits(a: u64, b: u64, l: u8, r: u8) -> (u64, u64) {
        assert(l >= 0u8 && l < 8u8);
        assert(r >= 0u8 && r < 8u8);

        if a == b {
            if l == r {
                return (a, b);
            } else {
                let new_a: u64 = swap_bytes(a, l, r);
                return (new_a, new_a);
            }
        } else {
            let a_shift: u8 = 8u8 * (7u8 - l);
            let a_mask: u64 = 255u64 << a_shift;
            let a_bits: u64 = (a & a_mask) >> a_shift;

            let b_shift: u8 = 8u8 * (7u8 - r);
            let b_mask: u64 = 255u64 << b_shift;
            let b_bits: u64 = (b & b_mask) >> b_shift;

            // Handle Leo's ETYC0372003 error, we define the intermedia value
            let a_left: u64 = a & !a_mask;
            let a_right: u64 = b_bits << a_shift;
            let new_a: u64 = a_left | a_right;

            let b_left: u64 = b & !b_mask;
            let b_right: u64 = a_bits << b_shift;
            let new_b: u64 = b_left | b_right;

            return (new_a, new_b);
        }
    }

    // Swap byte for one u64 by two index.
    inline swap_bytes(u: u64, i: u8, j: u8) -> u64 {
        // Extract the bytes at positions i and j
        let i_shift: u8 = (7u8 - i) * 8u8;
        let j_shift: u8 = (7u8 - j) * 8u8;
        let mask_i: u64 = u >> i_shift;
        let mask_j: u64 = u >> j_shift;
        let byte_i: u64 = mask_i & 255u64;
        let byte_j: u64 = mask_j & 255u64;

        // Clear the bytes at positions i and j in the original u64
        let left_mask_i: u64 = 255u64 << i_shift;
        let left_mask_j: u64 = 255u64 << j_shift;
        let u_without_bytes: u64 = u & !(left_mask_i | left_mask_j);

        // Create the new u64 with swapped bytes
        let shifted_i: u64 = byte_i << j_shift;
        let shifted_j: u64 = byte_j << i_shift;
        let new_u: u64 = u_without_bytes | shifted_i | shifted_j;

        return new_u;
    }

    // Choose cards from multiple cards by position.
    inline choose_cards(position: u8, cards0: u64, cards1: u64, cards2: u64, cards3: u64, cards4: u64, cards5: u64, cards6: u64) -> u64 {
        let cards: u64 = 0u64;
        if position >= 0u8 && position <= 7u8 {
            cards = cards0;
        }
        if position >= 8u8 && position <= 15u8 {
            cards = cards1;
        }
        if position >= 16u8 && position <= 23u8 {
            cards = cards2;
        }
        if position >= 24u8 && position <= 31u8 {
            cards = cards3;
        }
        if position >= 32u8 && position <= 39u8 {
            cards = cards4;
        }
        if position>= 40u8 && position <= 47u8 {
            cards = cards5;
        }
        if position >= 48u8 && position <= 51u8 {
            cards = cards6;
        }
        return cards;
    }

    // Obtain the byte from u64 by index
    // For now, Leo can't downcast from u64 to u8, so we just as u64 for one byte.
    inline obtain_byte(a: u64, i: u8) -> u64 {
        assert(i >= 0u8 && i < 8u8);
        let shift_amount: u8 = (7u8 - i) * 8u8;
        let mask: u64 = 255u64 << shift_amount;

        let ret: u64 = (a & mask) >> shift_amount;
        return ret;
    }

    // Choose one card from cards by position
    inline choose_card(position: u8, cards0: u64, cards1: u64, cards2: u64, cards3: u64, cards4: u64, cards5: u64, cards6: u64) -> u64 {
        let cards: u64 = choose_cards(position, cards0, cards1, cards2, cards3, cards4, cards5, cards6);
        let i: u8 = position % 8u8;
        let card_id: u64 = obtain_byte(cards, i);
        return card_id;
    }
}
