// The 'texasholdem' program.
program texasholdem.aleo {
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

    struct Card {
        suit: u8,
        number: u8,
    }

    struct Players {
        player0: address,
        player1: address,
        player2: address,
        player3: address,
    }

    struct Round {
        dealer: address,
        winer: address,
        placed: u8, // Number of players that participated
    }

    // (round_index, round)
    mapping rounds: u32 => Round;
    // (round_index, player_address)
    mapping players: u32 => Players;

    // Dealer start the new round with a random seed to shuffling the cards.
    transition new_round(round_index: u32, dealer: address, seed: u64) -> RandomSeed {
        // Dealer must start the new round, and anyone can be the dealer.
        assert_eq(dealer, self.caller);
        let random_seed: RandomSeed = RandomSeed {
            owner: dealer,
            provider: self.caller,
            round: round_index,
            seed: seed,
        };

        return random_seed then finalize(round_index, dealer);
    }

    finalize new_round(round_index: u32, dealer: address) {
        let contains: bool = Mapping::contains(rounds, round_index);
        assert(!contains);

        Mapping::set(rounds, round_index, Round {
            dealer: dealer,
            winer: dealer,
            placed: 0u8,
        });

        Mapping::set(players, round_index, Players {
            player0: dealer,
            player1: dealer,
            player2: dealer,
            player3: dealer,
        });
    }

    // Players place their bets to participate the round.
    // They provide a seed for dealer.
    transition place_bets(round_index: u32, dealer: address, seed: u64) -> RandomSeed {
        assert_neq(dealer, self.caller);
        let random_seed: RandomSeed = RandomSeed {
            owner: dealer,
            provider: self.caller,
            round: round_index,
            seed: seed,
        };

        return random_seed then finalize(self.caller, round_index, seed);
    }

    finalize place_bets(player: address, round_index: u32, seed: u64) {
        let round: Round = Mapping::get(rounds, round_index);
        assert(round.placed >= 0u8 && round.placed <= 3u8);
        let placed: u8 = round.placed;
        Mapping::set(rounds, round_index, Round {
            dealer: round.dealer,
            winer: round.winer,
            placed: placed + 1u8,
        });

        let player_list: Players = Mapping::get(players, round_index);
        if placed == 0u8 {
            Mapping::set(players, round_index, Players {
                player0: player,
                player1: player_list.player1,
                player2: player_list.player2,
                player3: player_list.player3,
            });
        }
        if placed == 1u8 {
            Mapping::set(players, round_index, Players {
                player0: player_list.player0,
                player1: player,
                player2: player_list.player2,
                player3: player_list.player3,
            });
        }
        if placed == 2u8 {
            Mapping::set(players, round_index, Players {
                player0: player_list.player0,
                player1: player_list.player1,
                player2: player,
                player3: player_list.player3,
            });
        }
        if placed == 3u8 {
            Mapping::set(players, round_index, Players {
                player0: player_list.player0,
                player1: player_list.player1,
                player2: player_list.player2,
                player3: player,
            });
        }
    }

    // The dealer uses players' 4 seed and his own seed,
    // obtain a number that determine the order of 52 cards.
    transition shuffling(round_index: u32, drs0: RandomSeed, drs1: RandomSeed, drs2: RandomSeed, drs3: RandomSeed, drsd: RandomSeed) -> CardList {
        // Only same round's random seed can be used.
        assert_eq(round_index, drs0.round);
        assert_eq(round_index, drs1.round);
        assert_eq(round_index, drs2.round);
        assert_eq(round_index, drs3.round);
        assert_eq(round_index, drsd.round);

        // Use random seed generating cards.
        let (cards0, cards1, cards2, cards3, cards4, cards5, cards6): (u64, u64, u64, u64, u64, u64, u64) = shuffle_cards(drs0.seed, drs1.seed, drs2.seed, drs3.seed, drsd.seed);

        // Since only dealer can use record, self.caller must be dealer.
        let card_list: CardList = CardList {
            owner: self.caller,
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
        return card_list then finalize(round_index, drs0.provider, drs1.provider, drs2.provider, drs3.provider, self.caller);
    }

    finalize shuffling(round_index: u32, player0: address, player1: address, player2: address, player3: address, dealer: address) {
        let round: Round = Mapping::get(rounds, round_index);
        // All player must be placed.
        assert_eq(round.placed, 4u8);
        // Dealer must be matched.
        assert_eq(round.dealer, dealer);

        // Check all providers matches players.
        let matched: u8 = 0u8;
        let player_list: Players = Mapping::get(players, round_index);
        if player0 == player_list.player0 || player0 == player_list.player1 || player0 == player_list.player2 || player0 == player_list.player3 {
            matched += 1u8;
        }
        if player1 == player_list.player0 || player1 == player_list.player1 || player1 == player_list.player2 || player1 == player_list.player3 {
            matched += 1u8;
        }
        if player2 == player_list.player0 || player2 == player_list.player1 || player2 == player_list.player2 || player2 == player_list.player3 {
            matched += 1u8;
        }
        if player3 == player_list.player0 || player3 == player_list.player1 || player3 == player_list.player2 || player3 == player_list.player3 {
            matched += 1u8;
        }
        assert_eq(matched, 4u8);
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
            let l_idx: u8 = 0u8;
            let r_idx: u8 = 0u8;

            // Find target two cards by i, j.
            if i >= 0u8 && i <= 7u8 {
                left = cards0;
                l_idx = i;
            }
            if i >= 8u8 && i <= 15u8 {
                left = cards1;
                l_idx = i.mod(8u8);
            }
            if i >= 16u8 && i <= 23u8 {
                left = cards2;
                l_idx = i.mod(8u8);
            }
            if i >= 24u8 && i <= 31u8 {
                left = cards3;
                l_idx = i.mod(8u8);
            }
            if i >= 32u8 && i <= 39u8 {
                left = cards4;
                i = i.mod(8u8);
            }
            if i>= 40u8 && i <= 47u8 {
                left = cards5;
                l_idx = i.mod(8u8);
            }
            if i >= 48u8 && i <= 51u8 {
                left = cards6;
                l_idx = i.mod(8u8);
            }

            if j >= 0u8 && j <= 7u8 {
                right = cards0;
                r_idx = j;
            }
            if j >= 8u8 && j <= 15u8 {
                right = cards1;
                r_idx = j.mod(8u8);
            }
            if j >= 16u8 && j <= 23u8 {
                right = cards2;
                r_idx = j.mod(8u8);
            }
            if j >= 24u8 && j <= 31u8 {
                right = cards3;
                r_idx = j.mod(8u8);
            }
            if j >= 32u8 && j <= 39u8 {
                right = cards4;
                r_idx = j.mod(8u8);
            }
            if j>= 40u8 && j <= 47u8 {
                right = cards5;
                r_idx = j.mod(8u8);
            }
            if j >= 48u8 && j <= 51u8 {
                right = cards6;
                r_idx = j.mod(8u8);
            }

            // Do the swap
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
        }

        return (cards0, cards1, cards2, cards3, cards4, cards5, cards6);
    }

    // Swap 8 bits for two u64 by index
    inline swap_bits(a: u64, b: u64, l: u8, r: u8) -> (u64, u64) {
        assert(l < 8u8);
        assert(r < 8u8);

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
